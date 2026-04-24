class AddSkillBonusesToCharacterSheets < ActiveRecord::Migration[8.1]
  def change
    add_column :character_sheets, :skill_bonuses, :jsonb, default: {}
  end
end
