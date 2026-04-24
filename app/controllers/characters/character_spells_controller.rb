class Characters::CharacterSpellsController < ApplicationController
  include CharacterScoped

  before_action :set_spell, only: %i[ destroy ]

  def new
    @spell = @character.character_spells.build
  end

  def create
    @spell = @character.character_spells.build(spell_params)

    if @spell.save
      redirect_to character_inventory_items_path(@character), notice: "Spell added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @spell.destroy!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@spell) }
      format.html         { redirect_to character_inventory_items_path(@character), notice: "Spell removed." }
    end
  end

  private
    def set_spell
      @spell = @character.character_spells.find(params[:id])
    end

    def spell_params
      params.expect(character_spell: [
        :name, :spell_level, :school, :casting_time, :range,
        :components, :duration, :description, :ritual,
        :concentration, :prepared, :spellcasting_class,
        :damage_dice, :damage_type, :attack_stat, :save_stat, :upcast_dice
      ])
    end
end
