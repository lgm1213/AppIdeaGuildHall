class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :campaign_memberships, dependent: :destroy
  has_many :campaigns, through: :campaign_memberships
  has_many :created_campaigns, class_name: "Campaign", foreign_key: :creator_id, dependent: :destroy
  has_many :characters, through: :campaign_memberships

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
end
