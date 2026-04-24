class CharacterSheet < ApplicationRecord
  STATS = %w[strength dexterity constitution intelligence wisdom charisma].freeze

  SKILLS = {
    "acrobatics"      => "dexterity",
    "animal_handling" => "wisdom",
    "arcana"          => "intelligence",
    "athletics"       => "strength",
    "deception"       => "charisma",
    "history"         => "intelligence",
    "insight"         => "wisdom",
    "intimidation"    => "charisma",
    "investigation"   => "intelligence",
    "medicine"        => "wisdom",
    "nature"          => "intelligence",
    "perception"      => "wisdom",
    "performance"     => "charisma",
    "persuasion"      => "charisma",
    "religion"        => "intelligence",
    "sleight_of_hand" => "dexterity",
    "stealth"         => "dexterity",
    "survival"        => "wisdom"
  }.freeze

  BACKGROUND_FIELDS = [
    [ "Personality Traits", :personality_traits ],
    [ "Ideals",             :ideals             ],
    [ "Bonds",              :bonds              ],
    [ "Flaws",              :flaws              ],
    [ "Backstory",          :backstory          ]
  ].freeze

  belongs_to :character

  validates :character_id, uniqueness: true

  # ── Stat access ────────────────────────────────────────────────────────────

  def stat(key)
    (stats || {}).stringify_keys[key.to_s].to_i
  end

  def stat_display(key)
    value = stat(key)
    value.nonzero? ? value.to_s : "—"
  end

  # ── Modifiers ──────────────────────────────────────────────────────────────

  def modifier_for(key)
    ((stat(key) - 10) / 2.0).floor
  end

  def modifier_string(key)
    signed modifier_for(key)
  end

  def saving_throw_modifier(stat_key)
    modifier_for(stat_key) + (proficient_in_save?(stat_key) ? effective_proficiency_bonus : 0)
  end

  def saving_throw_modifier_string(stat_key)
    signed saving_throw_modifier(stat_key)
  end

  def skill_bonus(skill_key)
    (skill_bonuses || {}).stringify_keys[skill_key.to_s].to_i
  end

  def skill_modifier(skill_key)
    ability = SKILLS[skill_key.to_s]
    return 0 unless ability
    modifier_for(ability) +
      (proficient_in_skill?(skill_key) ? effective_proficiency_bonus : 0) +
      skill_bonus(skill_key)
  end

  def skill_modifier_string(skill_key)
    signed skill_modifier(skill_key)
  end

  def passive_perception
    10 + skill_modifier("perception")
  end

  def initiative_string
    mod = initiative.present? ? initiative.to_i : modifier_for("dexterity")
    signed mod
  end

  def effective_proficiency_bonus
    proficiency_bonus.to_i.nonzero? || 2
  end

  # ── Proficiency checks ─────────────────────────────────────────────────────

  def proficient_in_save?(stat_key)
    truthy? (saving_throw_proficiencies || {}).stringify_keys[stat_key.to_s]
  end

  def proficient_in_skill?(skill_key)
    truthy? (skill_proficiencies || {}).stringify_keys[skill_key.to_s]
  end

  # ── Display helpers (keep presentation strings out of views) ───────────────

  def skill_display_name(skill_key)
    skill_key.to_s.tr("_", " ").split.map(&:capitalize).join(" ")
  end

  def ability_abbreviation(stat_key)
    stat_key.to_s.upcase[0..2]
  end

  def skill_ability_abbr(skill_key)
    ability = SKILLS[skill_key.to_s]
    ability ? ability_abbreviation(ability) : "???"
  end

  # Returns only non-blank background fields as [{label:, value:}] pairs
  def background_sections
    BACKGROUND_FIELDS.filter_map do |label, method|
      value = public_send(method)
      { label: label, value: value } if value.present?
    end
  end

  private
    def signed(int)
      int >= 0 ? "+#{int}" : int.to_s
    end

    def truthy?(val)
      ActiveModel::Type::Boolean.new.cast(val)
    end
end
