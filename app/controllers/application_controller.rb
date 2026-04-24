class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :set_current_campaign

  private

  def set_current_campaign
    return unless params[:campaign_id]

    Current.campaign = Current.user.campaigns.find(params[:campaign_id])
    Current.membership = Current.campaign.campaign_memberships.find_by!(user: Current.user)
  end

  def require_gm!
    head :forbidden unless Current.membership&.game_master?
  end

  def can_act_for_participant?(participant)
    Current.membership.game_master? || participant&.owned_by?(Current.membership)
  end
end
