class CreateCampaignMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_memberships, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :campaign, type: :uuid, null: false, foreign_key: true
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    add_index :campaign_memberships, [ :user_id, :campaign_id ], unique: true
  end
end
