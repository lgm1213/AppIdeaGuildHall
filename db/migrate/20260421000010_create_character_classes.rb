class CreateCharacterClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :character_classes, id: :uuid do |t|
      t.references :character, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :subclass
      t.integer :level, null: false, default: 1
      t.string :hit_dice
      t.jsonb :features, null: false, default: {}

      t.timestamps
    end
  end
end
