class CombatAction < ApplicationRecord
  belongs_to :combat_round
  belongs_to :actor, class_name: "EncounterParticipant"
  belongs_to :target, class_name: "EncounterParticipant", optional: true

  enum :action_type, {
    other: 0,
    attack: 1,
    spell: 2,
    ability: 3,
    item: 4,
    movement: 5
  }

  validates :action_type, presence: true
end
