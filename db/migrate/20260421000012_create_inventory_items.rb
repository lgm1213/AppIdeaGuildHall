class CreateInventoryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_items, id: :uuid do |t|
      t.references :character, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :quantity, null: false, default: 1
      t.decimal :weight, precision: 8, scale: 2
      t.boolean :equipped, null: false, default: false
      t.integer :item_type, null: false, default: 0
      t.jsonb :properties, null: false, default: {}

      t.timestamps
    end
  end
end
