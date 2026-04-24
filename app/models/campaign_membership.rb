class CampaignMembership < ApplicationRecord
  belongs_to :user
  belongs_to :campaign

  has_one :character, dependent: :destroy
  has_many :session_attendances, dependent: :destroy

  enum :role, { player: 0, game_master: 1 }

  validates :role, presence: true
  validate :one_gm_per_campaign, if: :game_master?

  def game_master?
    role == "game_master"
  end

  def player?
    role == "player"
  end

  private

  def one_gm_per_campaign
    existing = campaign.campaign_memberships.where(role: :game_master)
    existing = existing.where.not(id: id) if persisted?
    errors.add(:role, "campaign already has a Game Master") if existing.exists?
  end
end
