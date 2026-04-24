class Campaigns::NpcsController < ApplicationController
  include CampaignScoped

  before_action :require_gm!
  before_action :set_npc, only: %i[ show edit update destroy ]

  def index
    @npcs = @campaign.npcs.alphabetically
  end

  def show
  end

  def new
    @npc = @campaign.npcs.build
  end

  def create
    @npc = @campaign.npcs.build(npc_params)

    if @npc.save
      redirect_to campaign_npc_path(@campaign, @npc), notice: "NPC created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @npc.update(npc_params)
      redirect_to campaign_npc_path(@campaign, @npc), notice: "NPC updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @npc.destroy!
    redirect_to campaign_npcs_path(@campaign), notice: "NPC removed."
  end

  private
    def set_npc
      @npc = @campaign.npcs.find(params[:id])
    end

    def npc_params
      params.expect(npc: [ :name, :role, :description, :notes, stats: {} ])
    end
end
