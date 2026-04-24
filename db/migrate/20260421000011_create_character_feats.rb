class CreateCharacterFeats < ActiveRecord::Migration[8.1]
  def change
    create_table :character_feats, id: :uuid do |t|
      t.references :character, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.string :source

      t.timestamps
    end
  end
end
