class AddCurrentTurnOrderToEncounters < ActiveRecord::Migration[8.1]
  def change
    add_column :encounters, :current_turn_order, :integer
  end
end
