class Campaigns::CombatActionsController < ApplicationController
  before_action :set_encounter
  before_action :require_actor_access!

  def create
    actor  = @encounter.encounter_participants.find(action_params[:actor_id])
    target = @encounter.encounter_participants.find_by(id: action_params[:target_id])
    round  = @encounter.current_round || @encounter.combat_rounds.create!(round_number: 1)
    damage = action_params[:damage_dealt].to_i
    hit    = action_params[:hit] == "true"

    CombatAction.create!(
      combat_round: round,
      actor:        actor,
      target:       target,
      action_type:  action_params[:action_type].presence || "other",
      description:  build_description(actor, target, action_params),
      attack_roll:  action_params[:attack_roll].presence&.to_i,
      hit:          action_params[:hit].present? ? hit : nil,
      weapon_name:  action_params[:weapon_name].presence,
      damage_dealt: damage.positive? && hit ? damage : nil
    )

    target.take_damage!(damage) if target && damage.positive? && hit

    render_encounter_combat
  end

  private
    def set_encounter
      @encounter    = Encounter.joins(game_session: :campaign)
                               .where(campaigns: { id: Current.user.campaign_ids })
                               .find(params[:encounter_id])
      @game_session = @encounter.game_session
      @campaign     = @game_session.campaign
      Current.membership = @campaign.campaign_memberships.find_by!(user: Current.user)
    end

    def require_actor_access!
      return if Current.membership.game_master?
      actor = @encounter.encounter_participants.find_by(id: params.dig(:combat_action, :actor_id))
      return head :forbidden unless actor&.pc?
      head :forbidden unless actor.participantable.campaign_membership_id == Current.membership.id
    end

    def action_params
      params.expect(combat_action: [ :actor_id, :target_id, :action_type, :description,
                                      :damage_dealt, :attack_roll, :hit, :weapon_name ])
    end

    def build_description(actor, target, params)
      weapon = params[:weapon_name].presence
      target_name = target&.display_name
      hit = params[:hit] == "true"

      case params[:action_type]
      when "attack"
        base = weapon ? "#{actor.display_name} attacked with #{weapon}" : "#{actor.display_name} attacked"
        base += " → #{target_name}" if target_name
        hit ? "#{base} (hit, #{params[:damage_dealt]} damage)" : "#{base} (miss)"
      when "spell"
        base = weapon ? "#{actor.display_name} cast #{weapon}" : "#{actor.display_name} cast a spell"
        base += " → #{target_name}" if target_name
        hit ? "#{base} (hit, #{params[:damage_dealt]} damage)" : "#{base} (miss)"
      when "movement"
        "#{actor.display_name} dashed"
      when "ability"
        target_name ? "#{actor.display_name} used ability on #{target_name}" : "#{actor.display_name} used an ability"
      else
        params[:description].presence || "#{actor.display_name} took action"
      end
    end

    def render_encounter_combat
      @participants         = @encounter.encounter_participants.includes(:participantable).by_initiative
      @current_participant  = @encounter.current_participant
      @campaign_enemies     = @campaign.enemies.alphabetically
      already_added_ids     = @participants.select(&:pc?).map(&:participantable_id)
      @available_characters = @game_session.session_attendances
                                .includes(campaign_membership: :character)
                                .filter_map { |a| a.campaign_membership.character }
                                .reject { |c| already_added_ids.include?(c.id) }

      render turbo_stream: [
        turbo_stream.replace(
          "participants-panel",
          partial: "campaigns/encounters/participants_panel",
          locals: { encounter: @encounter, participants: @participants,
                    available_characters: @available_characters, campaign_enemies: @campaign_enemies }
        ),
        turbo_stream.replace(
          "action-panel",
          partial: "campaigns/encounters/action_panel",
          locals: { encounter: @encounter, current_participant: @current_participant,
                    participants: @participants,
                    can_act: can_act_for_participant?(@current_participant) }
        )
      ]
    end
end
