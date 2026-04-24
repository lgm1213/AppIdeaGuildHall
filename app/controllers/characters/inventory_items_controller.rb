class Characters::InventoryItemsController < ApplicationController
  include CharacterScoped

  before_action :set_item, only: %i[ update destroy ]

  def index
    @equipped_items   = @character.inventory_items.equipped.alphabetically
    @unequipped_items = @character.inventory_items.not_equipped.alphabetically
    @cantrips         = @character.character_spells.cantrips.by_level
    @leveled_spells   = @character.character_spells.leveled.by_level.group_by(&:spell_level)
    @spell_slots      = @character.spell_slots.order(:slot_level)
    @feats            = @character.character_feats.by_type
    @total_weight     = @character.inventory_items.sum("weight * quantity")
    @spells_count     = @character.character_spells.count
  end

  def new
    @item = @character.inventory_items.build
  end

  def create
    @item = @character.inventory_items.build(item_params)

    if @item.save
      redirect_to character_inventory_items_path(@character), notice: "Item added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@item, partial: "inventory_item", locals: { inventory_item: @item, character: @character }) }
        format.html         { redirect_to character_inventory_items_path(@character) }
      end
    else
      redirect_to character_inventory_items_path(@character), alert: @item.errors.full_messages.first
    end
  end

  def destroy
    @item.destroy!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@item) }
      format.html         { redirect_to character_inventory_items_path(@character) }
    end
  end

  private
    def set_item
      @item = @character.inventory_items.find(params[:id])
    end

    def item_params
      params.expect(inventory_item: [
        :name, :description, :quantity, :weight, :equipped, :item_type,
        :damage_dice, :damage_type, :attack_stat, :attack_bonus, :damage_bonus, :reach
      ])
    end
end
