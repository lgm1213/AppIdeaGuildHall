class CharacterClass < ApplicationRecord
  belongs_to :character

  validates :name, presence: true
  validates :level, numericality: { greater_than: 0, less_than_or_equal_to: 20 }

  after_update_commit :log_level_up, if: :saved_change_to_level?

  private
    def log_level_up
      old_level, new_level = saved_change_to_level
      character.campaign.campaign_events.create!(
        character: character,
        event_type: :level_up,
        description: "#{character.name} reached #{name} level #{new_level}",
        metadata: { class_name: name, from: old_level, to: new_level }
      )
    end
end
