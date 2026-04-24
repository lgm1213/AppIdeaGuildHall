class Campaigns::TurnsController < ApplicationController
  before_action :set_encounter
  before_action :require_turn_access!

  def update
    @encounter.advance_turn!
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

    def require_turn_access!
      return if Current.membership.game_master?
      current_p = @encounter.current_participant
      return head :forbidden unless current_p&.pc?
      head :forbidden unless current_p.participantable.campaign_membership_id == Current.membership.id
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
