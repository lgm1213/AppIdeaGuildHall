class Campaign < ApplicationRecord
  belongs_to :game_system
  belongs_to :creator, class_name: "User"

  has_many :campaign_memberships, dependent: :destroy
  has_many :members, through: :campaign_memberships, source: :user
  has_many :characters, through: :campaign_memberships
  has_many :enemies, dependent: :destroy
  has_many :npcs, dependent: :destroy
  has_many :campaign_maps, dependent: :destroy
  has_many :game_sessions, dependent: :destroy
  has_many :campaign_events, dependent: :destroy
  has_one :invitation, class_name: "Campaign::Invitation", dependent: :destroy

  enum :status, { draft: 0, active: 1, paused: 2, completed: 3, archived: 4 }

  validates :name, presence: true

  scope :active_campaigns, -> { where(status: :active) }

  def gm_membership
    campaign_memberships.find_by(role: :game_master)
  end

  def game_master
    gm_membership&.user
  end

  def invitable?
    invitation.present?
  end

  def regenerate_invitation!
    invitation&.destroy
    create_invitation!
  end
end
