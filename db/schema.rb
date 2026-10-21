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

ActiveRecord::Schema[7.1].define(version: 2026_01_01_000700) do
  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "genre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendees", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "festivals", force: :cascade do |t|
    t.string "name", null: false
    t.date "starts_on", null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performances", force: :cascade do |t|
    t.datetime "starts_at", null: false
    t.integer "stage_id", null: false
    t.integer "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_performances_on_artist_id"
    t.index ["stage_id"], name: "index_performances_on_stage_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string "name", null: false
    t.integer "capacity", null: false
    t.integer "festival_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["festival_id"], name: "index_stages_on_festival_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "tier", null: false
    t.integer "price_cents", null: false
    t.integer "attendee_id", null: false
    t.integer "festival_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendee_id"], name: "index_tickets_on_attendee_id"
    t.index ["festival_id"], name: "index_tickets_on_festival_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title", null: false
    t.integer "length_sec", null: false
    t.integer "artist_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_tracks_on_artist_id"
  end

  add_foreign_key "performances", "artists"
  add_foreign_key "performances", "stages"
  add_foreign_key "stages", "festivals"
  add_foreign_key "tickets", "attendees"
  add_foreign_key "tickets", "festivals"
  add_foreign_key "tracks", "artists"
end
