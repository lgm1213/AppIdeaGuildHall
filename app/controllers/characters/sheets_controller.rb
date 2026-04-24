class Characters::SheetsController < ApplicationController
  include CharacterScoped

  before_action :set_sheet

  def show
    @health      = @character.health_status
    @classes     = @character.character_classes
    @spells      = @character.character_spells.where(prepared: true).order(:spell_level, :name)
    @spell_slots = @character.spell_slots.order(:slot_level)
    @weapons     = @character.inventory_items.where(item_type: :weapon, equipped: true)
  end

  def edit
  end

  def update
    if @sheet.update(sheet_params)
      redirect_to character_sheet_path(@character), notice: "Sheet updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_sheet
      @sheet = @character.character_sheet ||
               @character.create_character_sheet!(stats: {})
    end

    def sheet_params
      params.expect(
        character_sheet: [
          :proficiency_bonus, :initiative, :armor_class, :speed,
          :backstory, :personality_traits, :ideals, :bonds, :flaws, :appearance,
          stats: {},
          skill_proficiencies: {},
          skill_bonuses: {},
          saving_throw_proficiencies: {}
        ]
      )
    end
end
