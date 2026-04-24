class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.references :game_system, type: :uuid, null: false, foreign_key: true
      t.references :creator, type: :uuid, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
