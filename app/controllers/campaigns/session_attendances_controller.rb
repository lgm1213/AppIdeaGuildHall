class Campaigns::SessionAttendancesController < ApplicationController
  include CampaignScoped
  include GameSessionScoped

  before_action :require_gm!

  def create
    membership = @campaign.campaign_memberships.find(params[:campaign_membership_id])
    @game_session.session_attendances.create!(campaign_membership: membership)
    refresh_attendees_panel
  end

  def destroy
    @game_session.session_attendances.find(params[:id]).destroy!
    refresh_attendees_panel
  end

  private
    def refresh_attendees_panel
      @attendances = @game_session.session_attendances.includes(campaign_membership: :user)
      @available_memberships = @campaign.campaign_memberships.player
        .where.not(id: @attendances.map(&:campaign_membership_id))
        .includes(:user)

      render turbo_stream: turbo_stream.replace(
        "attendees-panel",
        partial: "campaigns/game_sessions/attendees_panel",
        locals: {
          campaign:              @campaign,
          game_session:          @game_session,
          attendances:           @attendances,
          available_memberships: @available_memberships
        }
      )
    end
end
