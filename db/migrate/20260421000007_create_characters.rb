class CreateCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :characters, id: :uuid do |t|
      t.references :campaign_membership, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :race
      t.string :alignment
      t.integer :experience_points, null: false, default: 0

      t.timestamps
    end
  end
end
