# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_22_220000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.uuid "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "campaign_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "campaign_id", null: false
    t.uuid "character_id"
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.integer "event_type", null: false
    t.jsonb "metadata", default: {}
    t.datetime "updated_at", null: false
    t.index ["campaign_id", "created_at"], name: "index_campaign_events_on_campaign_id_and_created_at"
    t.index ["campaign_id"], name: "index_campaign_events_on_campaign_id"
    t.index ["character_id"], name: "index_campaign_events_on_character_id"
  end

  create_table "campaign_invitations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "campaign_id", null: false
    t.datetime "created_at", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_invitations_on_campaign_id"
    t.index ["token"], name: "index_campaign_invitations_on_token", unique: true
  end

  create_table "campaign_maps", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "campaign_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "map_type", default: 0, null: false
    t.string "name", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_maps_on_campaign_id"
  end

  create_table "campaign_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "campaign_id", null: false
    t.datetime "created_at", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["campaign_id"], name: "index_campaign_memberships_on_campaign_id"
    t.index ["user_id", "campaign_id"], name: "index_campaign_memberships_on_user_id_and_campaign_id", unique: true
    t.index ["user_id"], name: "index_campaign_memberships_on_user_id"
  end

  create_table "campaigns", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "creator_id", null: false
    t.text "description"
    t.uuid "game_system_id", null: false
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_campaigns_on_creator_id"
    t.index ["game_system_id"], name: "index_campaigns_on_game_system_id"
  end

  create_table "character_classes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "character_id", null: false
    t.datetime "created_at", null: false
    t.jsonb "features", default: {}, null: false
    t.string "hit_dice"
    t.integer "level", default: 1, null: false
    t.string "name", null: false
    t.string "subclass"
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_classes_on_character_id"
  end

  create_table "character_feats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "character_id", null: false
    t.jsonb "combat_modifiers", default: {}
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "feat_type", default: 0, null: false
    t.string "name", null: false
    t.string "origin"
    t.string "source"
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_feats_on_character_id"
  end

  create_table "character_sheets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "appearance"
    t.integer "armor_class"
    t.text "backstory"
    t.text "bonds"
    t.uuid "character_id", null: false
    t.datetime "created_at", null: false
    t.text "flaws"
    t.text "ideals"
    t.integer "initiative"
    t.text "personality_traits"
    t.integer "proficiency_bonus"
    t.jsonb "saving_throw_proficiencies", default: {}, null: false
    t.jsonb "skill_bonuses", default: {}
    t.jsonb "skill_proficiencies", default: {}, null: false
    t.integer "speed"
    t.jsonb "stats", default: {}, null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_sheets_on_character_id", unique: true
  end

  create_table "character_spells", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "attack_stat"
    t.string "casting_time"
    t.uuid "character_id", null: false
    t.string "components"
    t.boolean "concentration", default: false, null: false
    t.datetime "created_at", null: false
    t.string "damage_dice"
    t.string "damage_type"
    t.text "description"
    t.string "duration"
    t.string "name", null: false
    t.boolean "prepared", default: false, null: false
    t.string "range"
    t.boolean "ritual", default: false, null: false
    t.string "save_stat"
    t.string "school"
    t.integer "spell_level", default: 0, null: false
    t.string "spellcasting_class"
    t.string "upcast_dice"
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_spells_on_character_id"
  end

  create_table "characters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "alignment"
    t.uuid "campaign_membership_id", null: false
    t.datetime "created_at", null: false
    t.integer "experience_points", default: 0, null: false
    t.string "name", null: false
    t.string "race"
    t.datetime "updated_at", null: false
    t.index ["campaign_membership_id"], name: "index_characters_on_campaign_membership_id"
  end

  create_table "combat_actions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "action_type", default: 0, null: false
    t.uuid "actor_id", null: false
    t.integer "attack_roll"
    t.uuid "combat_round_id", null: false
    t.datetime "created_at", null: false
    t.integer "damage_dealt"
    t.text "description"
    t.boolean "hit"
    t.text "notes"
    t.uuid "target_id"
    t.datetime "updated_at", null: false
    t.string "weapon_name"
    t.index ["actor_id"], name: "index_combat_actions_on_actor_id"
    t.index ["combat_round_id"], name: "index_combat_actions_on_combat_round_id"
    t.index ["target_id"], name: "index_combat_actions_on_target_id"
  end

  create_table "combat_rounds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "encounter_id", null: false
    t.integer "round_number", null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id", "round_number"], name: "index_combat_rounds_on_encounter_id_and_round_number", unique: true
    t.index ["encounter_id"], name: "index_combat_rounds_on_encounter_id"
  end

  create_table "encounter_participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_hp"
    t.uuid "encounter_id", null: false
    t.integer "initiative_order"
    t.integer "initiative_roll"
    t.string "label"
    t.uuid "participantable_id", null: false
    t.string "participantable_type", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["encounter_id"], name: "index_encounter_participants_on_encounter_id"
    t.index ["participantable_type", "participantable_id"], name: "idx_on_participantable_type_participantable_id_313873800a"
  end

  create_table "encounters", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_turn_order"
    t.text "description"
    t.uuid "game_session_id", null: false
    t.string "name", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["game_session_id"], name: "index_encounters_on_game_session_id"
  end

  create_table "enemies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "actions", default: {}, null: false
    t.string "alignment"
    t.integer "armor_class"
    t.uuid "campaign_id", null: false
    t.string "challenge_rating"
    t.string "condition_immunities"
    t.datetime "created_at", null: false
    t.string "damage_immunities"
    t.string "damage_resistances"
    t.text "description"
    t.string "enemy_type"
    t.string "hit_dice"
    t.integer "hit_points"
    t.integer "initiative_bonus", default: 0, null: false
    t.string "languages"
    t.jsonb "legendary_actions", default: {}
    t.string "name", null: false
    t.text "notes"
    t.integer "proficiency_bonus"
    t.string "saving_throws"
    t.string "senses"
    t.string "size"
    t.string "skills_text"
    t.string "speed"
    t.jsonb "stats", default: {}, null: false
    t.jsonb "traits", default: [], null: false
    t.datetime "updated_at", null: false
    t.integer "xp"
    t.index ["campaign_id"], name: "index_enemies_on_campaign_id"
  end

  create_table "game_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "campaign_id", null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.date "session_date"
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "xp_awarded"
    t.index ["campaign_id"], name: "index_game_sessions_on_campaign_id"
  end

  create_table "game_systems", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.jsonb "stat_template", default: {}, null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_game_systems_on_slug", unique: true
  end

  create_table "health_statuses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "character_id", null: false
    t.text "conditions", default: [], array: true
    t.datetime "created_at", null: false
    t.integer "current_hp", default: 0, null: false
    t.integer "death_save_failures", default: 0, null: false
    t.integer "death_save_successes", default: 0, null: false
    t.integer "max_hp", default: 0, null: false
    t.integer "temporary_hp", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_health_statuses_on_character_id", unique: true
  end

  create_table "inventory_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "attack_bonus", default: 0, null: false
    t.string "attack_stat"
    t.uuid "character_id", null: false
    t.datetime "created_at", null: false
    t.integer "damage_bonus", default: 0, null: false
    t.string "damage_dice"
    t.string "damage_type"
    t.text "description"
    t.boolean "equipped", default: false, null: false
    t.integer "item_type", default: 0, null: false
    t.string "name", null: false
    t.jsonb "properties", default: {}, null: false
    t.integer "quantity", default: 1, null: false
    t.integer "reach", default: 5, null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 8, scale: 2
    t.index ["character_id"], name: "index_inventory_items_on_character_id"
  end

  create_table "npcs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "campaign_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.text "notes"
    t.string "role"
    t.jsonb "stats", default: {}
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_npcs_on_campaign_id"
  end

  create_table "session_attendances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "campaign_membership_id", null: false
    t.datetime "created_at", null: false
    t.uuid "game_session_id", null: false
    t.uuid "proxy_user_id"
    t.datetime "updated_at", null: false
    t.index ["campaign_membership_id"], name: "index_session_attendances_on_campaign_membership_id"
    t.index ["game_session_id", "campaign_membership_id"], name: "idx_on_game_session_id_campaign_membership_id_524425fc60", unique: true
    t.index ["game_session_id"], name: "index_session_attendances_on_game_session_id"
    t.index ["proxy_user_id"], name: "index_session_attendances_on_proxy_user_id"
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.uuid "user_id", null: false
    t.index ["token"], name: "index_sessions_on_token", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "spell_slots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "character_id", null: false
    t.datetime "created_at", null: false
    t.integer "reset_on", default: 1, null: false
    t.integer "slot_level", null: false
    t.integer "total", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "used", default: 0, null: false
    t.index ["character_id", "slot_level"], name: "index_spell_slots_on_character_id_and_slot_level", unique: true
    t.index ["character_id"], name: "index_spell_slots_on_character_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campaign_events", "campaigns"
  add_foreign_key "campaign_events", "characters"
  add_foreign_key "campaign_invitations", "campaigns"
  add_foreign_key "campaign_maps", "campaigns"
  add_foreign_key "campaign_memberships", "campaigns"
  add_foreign_key "campaign_memberships", "users"
  add_foreign_key "campaigns", "game_systems"
  add_foreign_key "campaigns", "users", column: "creator_id"
  add_foreign_key "character_classes", "characters"
  add_foreign_key "character_feats", "characters"
  add_foreign_key "character_sheets", "characters"
  add_foreign_key "character_spells", "characters"
  add_foreign_key "characters", "campaign_memberships"
  add_foreign_key "combat_actions", "combat_rounds"
  add_foreign_key "combat_actions", "encounter_participants", column: "actor_id"
  add_foreign_key "combat_actions", "encounter_participants", column: "target_id"
  add_foreign_key "combat_rounds", "encounters"
  add_foreign_key "encounter_participants", "encounters"
  add_foreign_key "encounters", "game_sessions"
  add_foreign_key "enemies", "campaigns"
  add_foreign_key "game_sessions", "campaigns"
  add_foreign_key "health_statuses", "characters"
  add_foreign_key "inventory_items", "characters"
  add_foreign_key "npcs", "campaigns"
  add_foreign_key "session_attendances", "campaign_memberships"
  add_foreign_key "session_attendances", "game_sessions"
  add_foreign_key "session_attendances", "users", column: "proxy_user_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "spell_slots", "characters"
end
