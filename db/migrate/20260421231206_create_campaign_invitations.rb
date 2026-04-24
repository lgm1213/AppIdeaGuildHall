class CreateCampaignInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_invitations, id: :uuid do |t|
      t.references :campaign, null: false, foreign_key: true, type: :uuid
      t.string :token, null: false

      t.timestamps
    end

    add_index :campaign_invitations, :token, unique: true
  end
end
