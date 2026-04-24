class CreateHealthStatuses < ActiveRecord::Migration[8.1]
  def change
    create_table :health_statuses, id: :uuid do |t|
      t.references :character, type: :uuid, null: false, foreign_key: true, index: { unique: true }
      t.integer :current_hp, null: false, default: 0
      t.integer :max_hp, null: false, default: 0
      t.integer :temporary_hp, null: false, default: 0
      t.integer :death_save_successes, null: false, default: 0
      t.integer :death_save_failures, null: false, default: 0
      t.text :conditions, array: true, default: []

      t.timestamps
    end
  end
end
