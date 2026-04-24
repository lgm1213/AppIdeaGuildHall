class CharacterFeat < ApplicationRecord
  belongs_to :character

  enum :feat_type, {
    feat:               0,
    class_feature:      1,
    racial_feature:     2,
    background_feature: 3
  }

  validates :name, presence: true

  scope :alphabetically, -> { order(:name) }
  scope :by_type,        -> { order(:feat_type, :name) }

  def type_label
    case feat_type
    when "feat"               then "Feat"
    when "class_feature"      then "Class Feature"
    when "racial_feature"     then "Racial Feature"
    when "background_feature" then "Background"
    end
  end

  def origin_label
    case feat_type
    when "class_feature"      then "Class"
    when "racial_feature"     then "Race"
    when "background_feature" then "Background"
    else                           "Origin"
    end
  end

  def origin_placeholder
    case feat_type
    when "class_feature"      then "e.g. Rogue"
    when "racial_feature"     then "e.g. Half-Elf"
    when "background_feature" then "e.g. Criminal"
    else                           ""
    end
  end

  def type_icon
    case feat_type
    when "feat"               then "star"
    when "class_feature"      then "swords"
    when "racial_feature"     then "cruelty_free"
    when "background_feature" then "person_book"
    end
  end

  def type_color
    case feat_type
    when "feat"               then "text-primary"
    when "class_feature"      then "text-secondary"
    when "racial_feature"     then "text-tertiary"
    when "background_feature" then "text-outline"
    end
  end

  def type_badge_classes
    case feat_type
    when "feat"               then "bg-primary/10 text-primary border-primary/20"
    when "class_feature"      then "bg-secondary/10 text-secondary border-secondary/20"
    when "racial_feature"     then "bg-tertiary/10 text-tertiary border-tertiary/20"
    when "background_feature" then "bg-surface-container text-outline border-outline-variant/30"
    end
  end
end
