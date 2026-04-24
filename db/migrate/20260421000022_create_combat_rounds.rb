class CreateCombatRounds < ActiveRecord::Migration[8.1]
  def change
    create_table :combat_rounds, id: :uuid do |t|
      t.references :encounter, type: :uuid, null: false, foreign_key: true
      t.integer :round_number, null: false

      t.timestamps
    end

    add_index :combat_rounds, [ :encounter_id, :round_number ], unique: true
  end
end
