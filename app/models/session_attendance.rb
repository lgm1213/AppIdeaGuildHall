class SessionAttendance < ApplicationRecord
  belongs_to :game_session
  belongs_to :campaign_membership
  belongs_to :proxy_user, class_name: "User", optional: true

  delegate :user, to: :campaign_membership
  delegate :character, to: :campaign_membership

  def controlled_by
    proxy_user || user
  end

  def proxied?
    proxy_user_id.present?
  end
end
