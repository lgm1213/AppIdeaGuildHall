class CampaignsController < ApplicationController
  before_action :set_campaign, only: %i[ show edit update destroy ]

  def index
    @campaigns = Current.user.campaigns
                        .includes(:game_system, campaign_memberships: :character)
                        .order(created_at: :desc)
  end

  def show
    @invitation    = @campaign.invitation
    @events        = @campaign.campaign_events.recent
    @game_sessions = @campaign.game_sessions.includes(:encounters).order(created_at: :desc).limit(10)
  end

  def new
    @campaign    = Campaign.new
    @game_systems = GameSystem.alphabetically
  end

  def create
    @campaign        = Campaign.new(campaign_params)
    @campaign.creator = Current.user

    if @campaign.save
      @campaign.campaign_memberships.create!(user: Current.user, role: :game_master)
      redirect_to @campaign, notice: "Campaign created!"
    else
      @game_systems = GameSystem.alphabetically
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @game_systems = GameSystem.alphabetically
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to @campaign, notice: "Campaign updated."
    else
      @game_systems = GameSystem.alphabetically
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @campaign.destroy!
    redirect_to campaigns_path, notice: "Campaign deleted."
  end

  private
    def set_campaign
      @campaign = Current.user.campaigns.find(params[:id])
    end

    def campaign_params
      params.expect(campaign: [ :name, :description, :status, :game_system_id ])
    end
end
