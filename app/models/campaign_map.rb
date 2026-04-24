class CampaignMap < ApplicationRecord
  belongs_to :campaign

  has_one_attached :image

  enum :map_type, { world: 0, region: 1, dungeon: 2, city: 3, other: 4 }

  scope :alphabetically, -> { order(:name) }

  validates :name, presence: true
end
