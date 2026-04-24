class Campaigns::CompletionsController < ApplicationController
  before_action :set_encounter
  before_action :require_gm!

  def create
    @encounter.complete!
    redirect_to encounter_path(@encounter), notice: "Encounter completed."
  end

  private
    def set_encounter
      @encounter    = Encounter.joins(game_session: :campaign)
                               .where(campaigns: { id: Current.user.campaign_ids })
                               .find(params[:encounter_id])
      @game_session = @encounter.game_session
      @campaign     = @game_session.campaign
      Current.membership = @campaign.campaign_memberships.find_by!(user: Current.user)
    end
end
