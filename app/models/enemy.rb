class Enemy < ApplicationRecord
  belongs_to :campaign

  validates :name, presence: true

  scope :alphabetically, -> { order(:name) }

  ABILITIES = %w[ strength dexterity constitution intelligence wisdom charisma ].freeze
  ABILITY_LABELS = { "strength" => "STR", "dexterity" => "DEX", "constitution" => "CON",
                     "intelligence" => "INT", "wisdom" => "WIS", "charisma" => "CHA" }.freeze

  def ability_score(key)
    stats[key.to_s].to_i
  end

  def ability_modifier(key)
    (ability_score(key) - 10) / 2
  end

  def modifier_label(key)
    mod = ability_modifier(key)
    mod >= 0 ? "+#{mod}" : mod.to_s
  end

  def type_line
    [ size, enemy_type, alignment ].compact_blank.join(", ")
  end

  def cr_line
    parts = [ challenge_rating.present? ? "CR #{challenge_rating}" : nil ]
    parts << "XP #{xp}"              if xp.present?
    parts << "PB +#{proficiency_bonus}" if proficiency_bonus.present?
    parts.compact.join("  ·  ")
  end
end
