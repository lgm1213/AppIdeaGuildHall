class AddCombatStatsToInventoryItems < ActiveRecord::Migration[8.1]
  def change
    add_column :inventory_items, :damage_dice,   :string
    add_column :inventory_items, :damage_type,   :string
    add_column :inventory_items, :attack_stat,   :string
    add_column :inventory_items, :attack_bonus,  :integer, default: 0, null: false
    add_column :inventory_items, :damage_bonus,  :integer, default: 0, null: false
    add_column :inventory_items, :reach,         :integer, default: 5,  null: false
  end
end
