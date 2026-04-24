class InvitationRedemptionsController < ApplicationController
  rate_limit to: 10, within: 5.minutes

  def create
    invitation = Campaign::Invitation.find_by(token: redemption_params[:code].strip.upcase)

    if invitation.nil?
      redirect_to campaigns_path, alert: "Invalid invite code. Check the code and try again."
      return
    end

    campaign = invitation.campaign

    if campaign.campaign_memberships.exists?(user: Current.user)
      redirect_to campaign_path(campaign), notice: "You're already a member of #{campaign.name}."
      return
    end

    campaign.campaign_memberships.create!(user: Current.user, role: :player)
    redirect_to campaign_path(campaign), notice: "Welcome to #{campaign.name}! Create your character to join the adventure."
  end

  private
    def redemption_params
      params.expect(invitation_redemption: [ :code ])
    end
end
