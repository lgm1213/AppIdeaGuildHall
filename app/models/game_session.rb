class GameSession < ApplicationRecord
  belongs_to :campaign

  has_many :session_attendances, dependent: :destroy
  has_many :attendees, through: :session_attendances, source: :campaign_membership
  has_many :encounters, dependent: :destroy

  enum :status, { planned: 0, completed: 1 }

  validates :title, presence: true

  scope :reverse_chronologically, -> { order(session_date: :desc, created_at: :desc) }
end
