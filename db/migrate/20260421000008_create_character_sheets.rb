class CreateCharacterSheets < ActiveRecord::Migration[8.1]
  def change
    create_table :character_sheets, id: :uuid do |t|
      t.references :character, type: :uuid, null: false, foreign_key: true, index: { unique: true }
      t.jsonb :stats, null: false, default: {}
      t.integer :proficiency_bonus
      t.integer :initiative
      t.integer :armor_class
      t.integer :speed
      t.jsonb :skill_proficiencies, null: false, default: {}
      t.jsonb :saving_throw_proficiencies, null: false, default: {}
      t.text :backstory
      t.text :personality_traits
      t.text :ideals
      t.text :bonds
      t.text :flaws
      t.text :appearance

      t.timestamps
    end
  end
end
