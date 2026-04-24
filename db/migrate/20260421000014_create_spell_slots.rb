class CreateSpellSlots < ActiveRecord::Migration[8.1]
  def change
    create_table :spell_slots, id: :uuid do |t|
      t.references :character, type: :uuid, null: false, foreign_key: true
      t.integer :slot_level, null: false
      t.integer :total, null: false, default: 0
      t.integer :used, null: false, default: 0
      t.integer :reset_on, null: false, default: 1

      t.timestamps
    end

    add_index :spell_slots, [ :character_id, :slot_level ], unique: true
  end
end
