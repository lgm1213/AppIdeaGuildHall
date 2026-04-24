module CampaignScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_campaign
  end

  private
    def set_campaign
      @campaign = Current.user.campaigns.find(params[:campaign_id])
    end
end
