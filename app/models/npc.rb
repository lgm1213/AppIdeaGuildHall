class Npc < ApplicationRecord
  belongs_to :campaign

  validates :name, presence: true

  scope :alphabetically, -> { order(:name) }
end
