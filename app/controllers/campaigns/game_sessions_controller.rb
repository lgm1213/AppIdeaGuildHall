class Campaigns::GameSessionsController < ApplicationController
  include CampaignScoped

  before_action :require_gm!, only: %i[ new create edit update destroy ]
  before_action :set_game_session, only: %i[ show edit update destroy ]

  def index
    @game_sessions = @campaign.game_sessions.reverse_chronologically
  end

  def show
    @encounters = @game_session.encounters.order(:created_at)
    @attendances = @game_session.session_attendances.includes(campaign_membership: :user)
    @available_memberships = @campaign.campaign_memberships.player
      .where.not(id: @attendances.map(&:campaign_membership_id))
      .includes(:user)
  end

  def new
    @game_session = @campaign.game_sessions.build
  end

  def create
    @game_session = @campaign.game_sessions.build(game_session_params)

    if @game_session.save
      redirect_to campaign_game_session_path(@campaign, @game_session), notice: "Session created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @game_session.update(game_session_params)
      redirect_to campaign_game_session_path(@campaign, @game_session), notice: "Session updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @game_session.destroy!
    redirect_to campaign_path(@campaign), notice: "Session deleted."
  end

  private
    def set_game_session
      @game_session = @campaign.game_sessions.find(params[:id])
    end

    def game_session_params
      params.expect(game_session: [ :title, :session_date, :notes, :xp_awarded, :status ])
    end
end
