class CreateEncounters < ActiveRecord::Migration[8.1]
  def change
    create_table :encounters, id: :uuid do |t|
      t.references :game_session, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
