class CreateCampaignEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_events, id: :uuid do |t|
      t.references :campaign,  null: false, foreign_key: true, type: :uuid
      t.references :character, null: true,  foreign_key: true, type: :uuid
      t.integer :event_type, null: false
      t.string  :description, null: false
      t.jsonb   :metadata, default: {}
      t.timestamps
    end

    add_index :campaign_events, [ :campaign_id, :created_at ]
  end
end
