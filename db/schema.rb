# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131204061959) do

  create_table "devices", force: true do |t|
    t.string   "registration_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.string   "type"
    t.text     "memo"
    t.string   "app_version"
    t.string   "os_version"
    t.string   "sdk_version"
    t.string   "manufacturer"
    t.string   "model"
    t.string   "username"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "event"
    t.string   "site"
    t.datetime "date_started"
    t.integer  "round"
    t.integer  "white_player_id"
    t.integer  "black_player_id"
    t.string   "result"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "game_type"
    t.text     "actual_game"
    t.datetime "date_finished"
    t.string   "game_status"
  end

  create_table "users", force: true do |t|
    t.string   "google_plus_id"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

end
