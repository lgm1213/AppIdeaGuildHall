class EncounterParticipant < ApplicationRecord
  belongs_to :encounter
  belongs_to :participantable, polymorphic: true

  has_many :actions_taken,    class_name: "CombatAction", foreign_key: :actor_id,  dependent: :destroy
  has_many :actions_received, class_name: "CombatAction", foreign_key: :target_id, dependent: :nullify

  enum :status, { active: 0, unconscious: 1, dead: 2, fled: 3 }

  scope :by_initiative, -> { order(:initiative_order) }
  scope :hostile,       -> { where(participantable_type: [ "Enemy" ]) }
  scope :friendly,      -> { where(participantable_type: [ "Character" ]) }

  def display_name
    label.presence || participantable.name
  end

  def initiative_modifier
    case participantable
    when Character then participantable.character_sheet&.initiative.to_i
    when Enemy     then participantable.initiative_bonus.to_i
    end
  end

  def display_ac
    case participantable
    when Character then participantable.character_sheet&.armor_class
    when Enemy     then participantable.armor_class
    end
  end

  def attack_options
    return [] unless participantable_type == "Character"
    participantable.inventory_items.where(item_type: :weapon, equipped: true)
  end

  def weapon_attacks
    attack_options.map do |w|
      { name: w.name, bonus: to_hit_bonus_for(w),
        dice: w.damage_dice.presence || "1d4", damage_type: w.damage_type.presence || "—",
        is_save: false, kind: :weapon }
    end
  end

  def spell_attacks
    return [] unless pc?
    participantable.character_spells
      .where.not(damage_dice: [ nil, "" ])
      .order(:spell_level, :name)
      .map do |spell|
        is_save = spell.save_stat.present?
        {
          name:        spell.name,
          bonus:       is_save ? spell_save_dc_for(spell) : spell_attack_bonus_for(spell),
          dice:        spell.damage_dice,
          damage_type: spell.damage_type.presence || "—",
          is_save:     is_save,
          save_stat:   spell.save_stat,
          spell_level: spell.spell_level,
          kind:        :spell
        }
      end
  end

  def ability_attacks
    return [] unless pc?
    participantable.character_feats
      .where("combat_modifiers->>'damage_dice' IS NOT NULL AND combat_modifiers->>'damage_dice' != ''")
      .order(:name)
      .map do |feat|
        mods    = feat.combat_modifiers
        is_save = mods["save_stat"].present?
        {
          name:        feat.name,
          bonus:       mods["attack_bonus"].to_i,
          dice:        mods["damage_dice"],
          damage_type: mods["damage_type"].presence || "—",
          is_save:     is_save,
          save_stat:   mods["save_stat"],
          kind:        :ability
        }
      end
  end

  def all_attacks
    if pc?
      weapon_attacks + spell_attacks + ability_attacks
    else
      acts = participantable.actions
      list = acts.is_a?(Hash) ? (acts["standard"] || []).filter_map { |a|
        next unless a["name"].present?
        bonus = a["attack_bonus"]&.to_i || a["hit_bonus"].to_s.delete("^0-9\\-").to_i
        { name: a["name"], bonus: bonus,
          dice: a["damage"].presence || "1d4", damage_type: a["damage_type"].presence || "",
          is_save: false, kind: :attack }
      } : []
      list.empty? ? [ { name: "Attack", bonus: 0, dice: "1d4", damage_type: "—", is_save: false, kind: :attack } ] : list
    end
  end

  def to_hit_bonus_for(weapon)
    return weapon.attack_bonus.to_i unless pc?
    sheet = participantable.character_sheet
    return weapon.attack_bonus.to_i unless sheet

    stat_key = weapon.attack_stat.presence || "strength"
    stat_val  = (sheet.stats || {})[stat_key].to_i
    modifier  = (stat_val - 10) / 2
    sheet.proficiency_bonus.to_i + modifier + weapon.attack_bonus.to_i
  end

  def take_damage!(amount)
    new_hp = [ (current_hp || 0) - amount, 0 ].max
    if new_hp == 0
      new_status = participantable_type == "Character" ? :unconscious : :dead
      update!(current_hp: 0, status: new_status)
    else
      update!(current_hp: new_hp)
    end
  end

  def heal!(amount)
    cap = case participantable
    when Character then participantable.health_status&.max_hp || current_hp.to_i
    when Enemy     then participantable.hit_points.to_i
    else current_hp.to_i
    end
    update!(current_hp: [ (current_hp || 0) + amount, cap ].min, status: :active)
  end

  def pc?
    participantable_type == "Character"
  end

  def owned_by?(membership)
    pc? && participantable.campaign_membership_id == membership.id
  end

  private
    def spell_attack_bonus_for(spell)
      sheet = participantable.character_sheet
      return 0 unless sheet
      stat_key = spell.attack_stat.presence || "intelligence"
      stat_val = (sheet.stats || {})[stat_key].to_i
      modifier = (stat_val - 10) / 2
      sheet.proficiency_bonus.to_i + modifier
    end

    def spell_save_dc_for(spell)
      sheet = participantable.character_sheet
      return 8 unless sheet
      cast_key = spell.attack_stat.presence || "intelligence"
      stat_val = (sheet.stats || {})[cast_key].to_i
      modifier = (stat_val - 10) / 2
      8 + sheet.proficiency_bonus.to_i + modifier
    end
end
