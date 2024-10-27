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

ActiveRecord::Schema[7.2].define(version: 2024_10_27_042303) do
  create_table "match_champions", force: :cascade do |t|
    t.integer "match_id", null: false
    t.integer "champion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_match_champions_on_match_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string "match_id"
    t.integer "user_id", null: false
    t.string "game_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_matches_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.integer "match_id", null: false
    t.string "participant_id"
    t.integer "placement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_participants_on_match_id"
  end

  create_table "units", force: :cascade do |t|
    t.integer "participant_id", null: false
    t.string "character_id"
    t.integer "tier"
    t.text "items"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id"], name: "index_units_on_participant_id"
  end

  create_table "user_matches", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "match_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_user_matches_on_match_id"
    t.index ["user_id"], name: "index_user_matches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "riot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "puuid"
  end

  add_foreign_key "match_champions", "matches"
  add_foreign_key "matches", "users"
  add_foreign_key "participants", "matches"
  add_foreign_key "units", "participants"
  add_foreign_key "user_matches", "matches"
  add_foreign_key "user_matches", "users"
end
