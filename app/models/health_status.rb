class HealthStatus < ApplicationRecord
  belongs_to :character

  validates :character_id, uniqueness: true
  validates :current_hp, :max_hp, :temporary_hp, numericality: { greater_than_or_equal_to: 0 }
  validates :death_save_successes, :death_save_failures, numericality: { in: 0..3 }

  def unconscious?
    current_hp == 0
  end

  def dead?
    death_save_failures >= 3
  end

  def hp_percentage
    return 0 if max_hp == 0
    ((current_hp.to_f / max_hp) * 100).round
  end

  after_update_commit :log_hp_change,        if: :saved_change_to_current_hp?
  after_update_commit :log_condition_changes, if: :saved_change_to_conditions?

  def add_condition(condition)
    conditions << condition unless conditions.include?(condition)
    save!
  end

  def remove_condition(condition)
    conditions.delete(condition)
    save!
  end

  private
    def log_hp_change
      old_hp, new_hp = saved_change_to_current_hp
      direction = new_hp > old_hp ? "healed" : "took damage"
      delta = (new_hp - old_hp).abs
      character.campaign.campaign_events.create!(
        character: character,
        event_type: :hp_changed,
        description: "#{character.name} #{direction} #{delta} HP (#{old_hp} → #{new_hp})",
        metadata: { from: old_hp, to: new_hp, delta: delta }
      )
    end

    def log_condition_changes
      old_conditions = saved_change_to_conditions.first || []
      new_conditions = saved_change_to_conditions.last  || []

      (new_conditions - old_conditions).each do |cond|
        character.campaign.campaign_events.create!(
          character: character,
          event_type: :condition_added,
          description: "#{character.name} gained condition: #{cond.capitalize}"
        )
      end

      (old_conditions - new_conditions).each do |cond|
        character.campaign.campaign_events.create!(
          character: character,
          event_type: :condition_removed,
          description: "#{character.name} recovered from: #{cond.capitalize}"
        )
      end
    end
end
