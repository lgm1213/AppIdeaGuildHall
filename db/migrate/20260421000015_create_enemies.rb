class CreateEnemies < ActiveRecord::Migration[8.1]
  def change
    create_table :enemies, id: :uuid do |t|
      t.references :campaign, type: :uuid, null: false, foreign_key: true
      t.string :name, null: false
      t.string :enemy_type
      t.string :challenge_rating
      t.text :description
      t.jsonb :stats, null: false, default: {}
      t.jsonb :actions, null: false, default: {}
      t.jsonb :legendary_actions, default: {}
      t.text :notes

      t.timestamps
    end
  end
end
