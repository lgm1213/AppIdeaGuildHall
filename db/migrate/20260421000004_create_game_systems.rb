class CreateGameSystems < ActiveRecord::Migration[8.1]
  def change
    create_table :game_systems, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.jsonb :stat_template, null: false, default: {}

      t.timestamps
    end

    add_index :game_systems, :slug, unique: true
  end
end
