class AddCombatStatsToCharacterSpells < ActiveRecord::Migration[8.1]
  def change
    add_column :character_spells, :damage_dice,  :string
    add_column :character_spells, :damage_type,  :string
    add_column :character_spells, :attack_stat,  :string
    add_column :character_spells, :save_stat,    :string
    add_column :character_spells, :upcast_dice,  :string
  end
end
