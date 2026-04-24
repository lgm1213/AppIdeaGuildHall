class CreateCharacterSpells < ActiveRecord::Migration[8.1]
  def change
    create_table :character_spells, id: :uuid do |t|
      t.references :character, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :spell_level, null: false, default: 0
      t.string :school
      t.string :casting_time
      t.string :range
      t.string :components
      t.string :duration
      t.text :description
      t.boolean :ritual, null: false, default: false
      t.boolean :concentration, null: false, default: false
      t.boolean :prepared, null: false, default: false
      t.string :spellcasting_class

      t.timestamps
    end
  end
end
