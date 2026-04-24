class CreateCombatActions < ActiveRecord::Migration[8.1]
  def change
    create_table :combat_actions, id: :uuid do |t|
      t.references :combat_round, type: :uuid, null: false, foreign_key: true
      t.references :actor, type: :uuid, null: false, foreign_key: { to_table: :encounter_participants }
      t.references :target, type: :uuid, null: true, foreign_key: { to_table: :encounter_participants }
      t.integer :action_type, null: false, default: 0
      t.text :description
      t.integer :damage_dealt
      t.text :notes

      t.timestamps
    end
  end
end
