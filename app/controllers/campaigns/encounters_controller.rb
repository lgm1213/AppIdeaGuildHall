class Campaigns::EncountersController < ApplicationController
  before_action :set_game_session, only: %i[ index new create ]
  before_action :set_encounter,    only: %i[ show edit update destroy ]
  before_action :require_gm!,      except: %i[ show ]

  def index
    @encounters = @game_session.encounters.order(:created_at)
  end

  def show
    @participants         = @encounter.encounter_participants.includes(:participantable).by_initiative
    @current_participant  = @encounter.current_participant
    @can_act              = can_act_for_participant?(@current_participant)
    already_added_ids     = @participants.select { |p| p.participantable_type == "Character" }.map(&:participantable_id)
    @available_characters = @game_session.session_attendances
                              .includes(campaign_membership: :character)
                              .filter_map { |a| a.campaign_membership.character }
                              .reject { |c| already_added_ids.include?(c.id) }
    @campaign_enemies     = @campaign.enemies.alphabetically
  end

  def new
    @encounter = @game_session.encounters.build
  end

  def create
    @encounter = @game_session.encounters.build(encounter_params)

    if @encounter.save
      redirect_to campaign_game_session_path(@campaign, @game_session), notice: "Encounter created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @encounter.update(encounter_params)
      redirect_to encounter_path(@encounter), notice: "Encounter updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @encounter.destroy!
    redirect_to campaign_game_session_path(@campaign, @game_session), notice: "Encounter deleted."
  end

  private
    def set_game_session
      @campaign     = Current.user.campaigns.find(params[:campaign_id])
      @game_session = @campaign.game_sessions.find(params[:game_session_id])
    end

    def set_encounter
      @encounter    = Encounter.joins(game_session: :campaign)
                               .where(campaigns: { id: Current.user.campaign_ids })
                               .find(params[:id])
      @game_session = @encounter.game_session
      @campaign     = @game_session.campaign
      Current.membership = @campaign.campaign_memberships.find_by!(user: Current.user)
    end

    def encounter_params
      params.expect(encounter: [ :name, :description, :status ])
    end
end
