class AddLabelToEncounterParticipants < ActiveRecord::Migration[8.1]
  def change
    add_column :encounter_participants, :label, :string
  end
end
