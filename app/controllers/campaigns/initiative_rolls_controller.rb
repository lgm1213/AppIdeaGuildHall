class Campaigns::InitiativeRollsController < ApplicationController
  before_action :set_encounter
  before_action :require_gm!

  def create
    @encounter.roll_initiative!
    redirect_to encounter_path(@encounter), notice: "Initiative rolled — combat has begun!"
  end

  private
    def set_encounter
      @encounter    = Encounter.joins(game_session: :campaign)
                               .where(campaigns: { id: Current.user.campaign_ids })
                               .find(params[:encounter_id])
      @campaign     = @encounter.game_session.campaign
      Current.membership = @campaign.campaign_memberships.find_by!(user: Current.user)
    end
end
