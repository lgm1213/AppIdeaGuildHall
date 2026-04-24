class AddAttackFieldsToCombatActions < ActiveRecord::Migration[8.1]
  def change
    add_column :combat_actions, :attack_roll,  :integer
    add_column :combat_actions, :hit,          :boolean
    add_column :combat_actions, :weapon_name,  :string
  end
end
