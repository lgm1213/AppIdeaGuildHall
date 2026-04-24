class Campaigns::EnemiesController < ApplicationController
  include CampaignScoped

  before_action :require_gm!
  before_action :set_enemy, only: %i[ show edit update destroy ]

  def index
    @enemies = @campaign.enemies.alphabetically
  end

  def show
  end

  def new
    @enemy = @campaign.enemies.build
  end

  def create
    @enemy = @campaign.enemies.build(enemy_params)

    if @enemy.save
      redirect_to campaign_enemy_path(@campaign, @enemy), notice: "Enemy created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @enemy.update(enemy_params)
      redirect_to campaign_enemy_path(@campaign, @enemy), notice: "Enemy updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @enemy.destroy!
    redirect_to campaign_enemies_path(@campaign), notice: "Enemy removed."
  end

  private
    def set_enemy
      @enemy = @campaign.enemies.find(params[:id])
    end

    def enemy_params
      params.expect(enemy: [
        :name, :size, :alignment, :enemy_type,
        :armor_class, :initiative_bonus, :hit_points, :hit_dice, :speed,
        :challenge_rating, :xp, :proficiency_bonus,
        :saving_throws, :skills_text,
        :damage_resistances, :damage_immunities, :condition_immunities,
        :senses, :languages,
        :description, :notes,
        stats: {},
        traits: [], actions: [], legendary_actions: []
      ])
    end
end
