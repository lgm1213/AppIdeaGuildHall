class Encounter < ApplicationRecord
  include Turbo::Broadcastable

  belongs_to :game_session

  has_many :encounter_participants, dependent: :destroy
  has_many :combat_rounds, dependent: :destroy

  enum :status, { pending: 0, active: 1, completed: 2 }

  after_update_commit :broadcast_turn_refresh, if: :saved_change_to_current_turn_order?

  validates :name, presence: true

  def current_round
    combat_rounds.order(:round_number).last
  end

  def current_participant
    if current_turn_order.present?
      encounter_participants.find_by(initiative_order: current_turn_order)
    else
      encounter_participants.where(status: :active).order(:initiative_order).first
    end
  end

  def initiative_order
    encounter_participants.order(:initiative_order)
  end

  def roll_initiative!
    encounter_participants.includes(:participantable).each do |participant|
      roll = rand(1..20) + participant.initiative_modifier
      participant.update_columns(initiative_roll: roll)
    end

    encounter_participants.order(initiative_roll: :desc).each_with_index do |participant, index|
      participant.update_columns(initiative_order: index + 1)
    end

    update!(status: :active, current_turn_order: 1)
    combat_rounds.create!(round_number: 1)
  end

  def advance_turn!
    eligible = encounter_participants.where(status: :active).order(:initiative_order).to_a
    return update!(current_turn_order: nil) if eligible.empty?

    current_idx = current_turn_order.present? ?
      eligible.index { |p| p.initiative_order == current_turn_order } : nil

    if current_idx.nil? || current_idx >= eligible.size - 1
      combat_rounds.create!(round_number: (current_round&.round_number || 0) + 1)
      update!(current_turn_order: eligible.first.initiative_order)
    else
      update!(current_turn_order: eligible[current_idx + 1].initiative_order)
    end
  end

  def complete!
    update!(status: :completed)
  end

  private
    def broadcast_turn_refresh
      broadcast_refresh_to self
    end
end
