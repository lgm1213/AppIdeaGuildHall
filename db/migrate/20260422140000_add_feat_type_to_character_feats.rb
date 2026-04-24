class AddFeatTypeToCharacterFeats < ActiveRecord::Migration[8.1]
  def change
    add_column :character_feats, :feat_type, :integer, null: false, default: 0
  end
end
