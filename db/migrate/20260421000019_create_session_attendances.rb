class CreateSessionAttendances < ActiveRecord::Migration[8.1]
  def change
    create_table :session_attendances, id: :uuid do |t|
      t.references :game_session, type: :uuid, null: false, foreign_key: true
      t.references :campaign_membership, type: :uuid, null: false, foreign_key: true
      t.references :proxy_user, type: :uuid, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :session_attendances, [ :game_session_id, :campaign_membership_id ], unique: true
  end
end
