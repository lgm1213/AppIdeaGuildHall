class CharacterSpell < ApplicationRecord
  belongs_to :character

  validates :name, presence: true
  validates :spell_level, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 9 }

  scope :cantrips, -> { where(spell_level: 0) }
  scope :leveled, -> { where.not(spell_level: 0) }
  scope :prepared, -> { where(prepared: true) }
  scope :by_level, -> { order(:spell_level, :name) }

  def cantrip?
    spell_level == 0
  end
end
