class CharactersController < ApplicationController
  before_action :set_character, only: %i[ show edit update destroy ]

  def show
    redirect_to character_sheet_path(@character)
  end

  def new
    @character = Character.new
  end

  def create
    @character = Current.membership.build_character(character_params)

    if @character.save
      @character.create_character_sheet!(stats: {})
      @character.create_health_status!(current_hp: 0, max_hp: 0)
      redirect_to character_sheet_path(@character), notice: "Character created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @character.update(character_params)
      redirect_to character_sheet_path(@character), notice: "Character updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    campaign = @character.campaign
    @character.destroy!
    redirect_to campaign_path(campaign), notice: "Character removed."
  end

  private
    def set_character
      @character = accessible_characters.find(params[:id])
    end

    def accessible_characters
      Character.joins(:campaign_membership)
               .where(campaign_memberships: { user_id: Current.user.id })
    end

    def character_params
      params.expect(character: [ :name, :race, :alignment, :experience_points ])
    end
end
