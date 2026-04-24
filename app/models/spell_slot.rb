class SpellSlot < ApplicationRecord
  belongs_to :character

  enum :reset_on, { short_rest: 0, long_rest: 1 }

  validates :slot_level, numericality: { in: 1..9 }
  validates :total, :used, numericality: { greater_than_or_equal_to: 0 }
  validate :used_cannot_exceed_total

  def remaining
    total - used
  end

  def expend!
    raise "No spell slots remaining at level #{slot_level}" if remaining == 0
    increment!(:used)
  end

  def recover_all!
    update!(used: 0)
  end

  private

  def used_cannot_exceed_total
    errors.add(:used, "cannot exceed total slots") if used > total
  end
end
