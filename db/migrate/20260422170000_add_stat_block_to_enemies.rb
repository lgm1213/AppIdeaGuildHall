class AddStatBlockToEnemies < ActiveRecord::Migration[8.1]
  def change
    add_column :enemies, :size,                 :string
    add_column :enemies, :alignment,            :string
    add_column :enemies, :armor_class,          :integer
    add_column :enemies, :initiative_bonus,     :integer, default: 0, null: false
    add_column :enemies, :hit_points,           :integer
    add_column :enemies, :hit_dice,             :string
    add_column :enemies, :speed,                :string
    add_column :enemies, :saving_throws,        :string
    add_column :enemies, :skills_text,          :string
    add_column :enemies, :damage_resistances,   :string
    add_column :enemies, :damage_immunities,    :string
    add_column :enemies, :condition_immunities, :string
    add_column :enemies, :senses,               :string
    add_column :enemies, :languages,            :string
    add_column :enemies, :xp,                   :integer
    add_column :enemies, :proficiency_bonus,    :integer
    add_column :enemies, :traits,               :jsonb, default: [], null: false
  end
end
