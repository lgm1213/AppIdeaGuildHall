module CharacterScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_character
  end

  private
    def set_character
      @character = accessible_characters.find(params[:character_id])
    end

    def accessible_characters
      gm_campaign_ids = Current.user.campaign_memberships
                                    .where(role: :game_master)
                                    .select(:campaign_id)

      own = Character.joins(:campaign_membership)
                     .where(campaign_memberships: { user_id: Current.user.id })

      gm_visible = Character.joins(:campaign_membership)
                             .where(campaign_memberships: { campaign_id: gm_campaign_ids })

      own.or(gm_visible)
    end
end
