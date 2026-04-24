class CreateEncounterParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :encounter_participants, id: :uuid do |t|
      t.references :encounter, type: :uuid, null: false, foreign_key: true
      t.string :participantable_type, null: false
      t.uuid :participantable_id, null: false
      t.integer :initiative_roll
      t.integer :initiative_order
      t.integer :current_hp
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :encounter_participants, [ :participantable_type, :participantable_id ]
  end
end
