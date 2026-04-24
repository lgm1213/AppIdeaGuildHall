class Campaigns::CampaignMapsController < ApplicationController
  include CampaignScoped

  before_action :require_gm!
  before_action :set_campaign_map, only: %i[ show edit update destroy ]

  def index
    @campaign_maps = @campaign.campaign_maps.alphabetically
  end

  def show
  end

  def new
    @campaign_map = @campaign.campaign_maps.build
  end

  def create
    @campaign_map = @campaign.campaign_maps.build(campaign_map_params)

    if @campaign_map.save
      redirect_to campaign_campaign_map_path(@campaign, @campaign_map), notice: "Map created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @campaign_map.update(campaign_map_params)
      redirect_to campaign_campaign_map_path(@campaign, @campaign_map), notice: "Map updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @campaign_map.destroy!
    redirect_to campaign_campaign_maps_path(@campaign), notice: "Map removed."
  end

  private
    def set_campaign_map
      @campaign_map = @campaign.campaign_maps.find(params[:id])
    end

    def campaign_map_params
      params.expect(campaign_map: [ :name, :description, :map_type, :notes, :image ])
    end
end
