class CreateCampaignMaps < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_maps, id: :uuid do |t|
      t.references :campaign, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :map_type, null: false, default: 0
      t.text :notes

      t.timestamps
    end
  end
end
