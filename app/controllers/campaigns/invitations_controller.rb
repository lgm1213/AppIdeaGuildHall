class Campaigns::InvitationsController < ApplicationController
  include CampaignScoped

  before_action :require_gm!

  def show
    @invitation = @campaign.invitation
  end

  def create
    @campaign.regenerate_invitation!
    redirect_to campaign_invitation_path(@campaign), notice: "New invite code generated."
  end

  def destroy
    @campaign.invitation&.destroy
    redirect_to campaign_invitation_path(@campaign), notice: "Invite code revoked."
  end
end
