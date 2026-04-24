class InventoryItem < ApplicationRecord
  belongs_to :character

  enum :item_type, {
    other: 0,
    weapon: 1,
    armor: 2,
    tool: 3,
    consumable: 4,
    treasure: 5
  }

  validates :name, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :equipped,     -> { where(equipped: true) }
  scope :not_equipped, -> { where(equipped: false) }
  scope :alphabetically, -> { order(:name) }
  scope :by_type,      ->(type) { where(item_type: type) }

  after_update_commit :log_equipped_change, if: :saved_change_to_equipped?

  def icon
    case item_type
    when "weapon"     then "swords"
    when "armor"      then "shield"
    when "consumable" then "pill"
    when "tool"       then "home_repair_service"
    when "treasure"   then "diamond"
    else                   "category"
    end
  end

  private
    def log_equipped_change
      type = equipped? ? :item_equipped : :item_unequipped
      verb = equipped? ? "equipped" : "unequipped"
      character.campaign.campaign_events.create!(
        character: character,
        event_type: type,
        description: "#{character.name} #{verb} #{name}"
      )
    end
end
