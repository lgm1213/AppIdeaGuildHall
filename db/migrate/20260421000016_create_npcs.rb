class CreateNpcs < ActiveRecord::Migration[8.1]
  def change
    create_table :npcs, id: :uuid do |t|
      t.references :campaign, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :role
      t.text :description
      t.jsonb :stats, default: {}
      t.text :notes

      t.timestamps
    end
  end
end
