class GameSystem < ApplicationRecord
  has_many :campaigns, dependent: :restrict_with_error

  scope :alphabetically, -> { order(name: :asc) }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9_]+\z/ }
  validates :stat_template, presence: true
end
