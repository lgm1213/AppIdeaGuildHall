module GameSessionScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_game_session
  end

  private
    def set_game_session
      @game_session = @campaign.game_sessions.find(params[:game_session_id])
    end
end
