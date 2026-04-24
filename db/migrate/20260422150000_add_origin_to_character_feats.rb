class AddOriginToCharacterFeats < ActiveRecord::Migration[8.1]
  def change
    add_column :character_feats, :origin, :string
  end
end
