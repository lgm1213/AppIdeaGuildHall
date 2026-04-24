class CampaignEvent < ApplicationRecord
  belongs_to :campaign
  belongs_to :character, optional: true

  enum :event_type, {
    character_joined:   0,
    level_up:           1,
    hp_changed:         2,
    condition_added:    3,
    condition_removed:  4,
    item_equipped:      5,
    item_unequipped:    6
  }

  scope :reverse_chronologically, -> { order(created_at: :desc) }
  scope :preloaded, -> { includes(:character) }
  scope :recent, -> { reverse_chronologically.limit(25).preloaded }

  def icon
    case event_type
    when "character_joined"  then "person_add"
    when "level_up"          then "trending_up"
    when "hp_changed"        then "favorite"
    when "condition_added"   then "coronavirus"
    when "condition_removed" then "healing"
    when "item_equipped"     then "shield"
    when "item_unequipped"   then "shield_locked"
    end
  end

  def icon_color
    case event_type
    when "character_joined"  then "text-primary"
    when "level_up"          then "text-secondary"
    when "hp_changed"        then "text-tertiary"
    when "condition_added"   then "text-error"
    when "condition_removed" then "text-tertiary"
    when "item_equipped"     then "text-primary"
    when "item_unequipped"   then "text-outline"
    end
  end
end
