class CreateGameSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :game_sessions, id: :uuid do |t|
      t.references :campaign, type: :uuid, null: false, foreign_key: true
      t.string :title, null: false
      t.date :session_date
      t.text :notes
      t.integer :xp_awarded
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
