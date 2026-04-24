class Character < ApplicationRecord
  belongs_to :campaign_membership

  has_one :user, through: :campaign_membership
  has_one :campaign, through: :campaign_membership
  has_one :character_sheet, dependent: :destroy
  has_one :health_status, dependent: :destroy
  has_many :character_classes, dependent: :destroy
  has_many :character_feats, dependent: :destroy
  has_many :inventory_items, dependent: :destroy
  has_many :character_spells, dependent: :destroy
  has_many :spell_slots, dependent: :destroy

  has_one_attached :avatar

  validates :name, presence: true

  delegate :campaign, to: :campaign_membership

  after_create_commit :log_joined

  def total_level
    character_classes.sum(:level)
  end

  private
    def log_joined
      campaign.campaign_events.create!(
        character: self,
        event_type: :character_joined,
        description: "#{name} joined the campaign"
      )
    end
end
