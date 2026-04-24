class AddCombatModifiersToCharacterFeats < ActiveRecord::Migration[8.1]
  def change
    add_column :character_feats, :combat_modifiers, :jsonb, default: {}
  end
end
