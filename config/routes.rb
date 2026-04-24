Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication
  resource :session, only: %i[ new create destroy ]
  resource :registration, only: %i[ new create ]
  resources :passwords, param: :token, only: %i[ new create edit update ]

  # Campaigns (lobby)
  resources :invitation_redemptions, only: %i[ create ]

  resources :campaigns do
    resource  :invitation,     module: :campaigns, only: %i[ show create destroy ]
    resources :memberships,    module: :campaigns, only: %i[ index create destroy ]
    resources :enemies,        module: :campaigns
    resources :npcs,           module: :campaigns
    resources :campaign_maps,  module: :campaigns
    resources :game_sessions,  module: :campaigns do
      resources :session_attendances, only: %i[ create destroy ]
      resources :encounters, shallow: true do
        resources :participants,    shallow: true, only: %i[ create update destroy ]
        resource  :initiative_roll, only: %i[ create ]
        resource  :turn,            only: %i[ update ]
        resources :combat_actions,  only: %i[ create ]
        resource  :completion,      only: %i[ create ]
      end
    end
  end

  # Characters
  resources :characters do
    resource  :sheet,           module: :characters, only: %i[ show edit update ]
    resource  :health_status,   module: :characters, only: %i[ show update ]
    resources :character_classes, module: :characters, only: %i[ index create update destroy ]
    resources :character_feats,   module: :characters, only: %i[ new create destroy ]
    resources :inventory_items,   module: :characters
    resources :character_spells,  module: :characters
    resources :spell_slots,       module: :characters, only: %i[ index update ]
  end

  root "campaigns#index"
end
