class CombatRound < ApplicationRecord
  belongs_to :encounter

  has_many :combat_actions, dependent: :destroy

  validates :round_number, presence: true, uniqueness: { scope: :encounter_id }

  scope :chronologically, -> { order(:round_number) }
end
