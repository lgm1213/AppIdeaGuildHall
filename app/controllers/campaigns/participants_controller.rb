class Campaigns::ParticipantsController < ApplicationController
  before_action :set_encounter,    only: %i[ create ]
  before_action :set_participant,  only: %i[ update destroy ]
  before_action :require_gm!

  def create
    case params[:participantable_type]
    when "Character"
      character = @campaign.characters.find(params[:participantable_id])
      @encounter.encounter_participants.create!(
        participantable: character,
        current_hp:      character.health_status&.current_hp
      )
    when "Enemy"
      enemy    = @campaign.enemies.find(params[:participantable_id])
      quantity = params[:quantity].to_i.clamp(1, 20)
      existing = @encounter.encounter_participants.where(participantable: enemy).count

      quantity.times do |i|
        n = existing + i + 1
        label = (existing + quantity > 1) ? "#{enemy.name} ##{n}" : nil
        @encounter.encounter_participants.create!(
          participantable: enemy,
          label:           label,
          current_hp:      enemy.hit_points
        )
      end
    end

    render_participants_panel
  end

  def update
    @participant.update!(participant_params)
    render_participants_panel
  end

  def destroy
    @participant.destroy!
    render_participants_panel
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

    def set_participant
      @participant  = EncounterParticipant.joins(encounter: { game_session: :campaign })
                                          .where(campaigns: { id: Current.user.campaign_ids })
                                          .find(params[:id])
      @encounter    = @participant.encounter
      @game_session = @encounter.game_session
      @campaign     = @game_session.campaign
      Current.membership = @campaign.campaign_memberships.find_by!(user: Current.user)
    end

    def participant_params
      params.expect(encounter_participant: [ :current_hp, :status ])
    end

    def render_participants_panel
      @participants         = @encounter.encounter_participants.includes(:participantable).by_initiative
      already_added_ids     = @participants.select { |p| p.participantable_type == "Character" }.map(&:participantable_id)
      @available_characters = @game_session.session_attendances
                                .includes(campaign_membership: :character)
                                .filter_map { |a| a.campaign_membership.character }
                                .reject { |c| already_added_ids.include?(c.id) }
      @campaign_enemies     = @campaign.enemies.alphabetically

      render turbo_stream: turbo_stream.replace(
        "participants-panel",
        partial: "campaigns/encounters/participants_panel",
        locals: {
          encounter:             @encounter,
          participants:          @participants,
          available_characters:  @available_characters,
          campaign_enemies:      @campaign_enemies
        }
      )
    end
end
