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

ActiveRecord::Schema.define(version: 20130607230546) do

  create_table "dropbox_connections", force: true do |t|
    t.integer  "user_id"
    t.text     "session",    limit: 255
    t.datetime "created_at"
    t.string   "state"
  end

  add_index "dropbox_connections", ["state"], name: "index_dropbox_connections_on_state"

  create_table "google_connections", force: true do |t|
    t.string   "state"
    t.datetime "created_at"
    t.integer  "user_id"
    t.text     "session",    limit: 255
  end

  add_index "google_connections", ["state"], name: "index_google_connections_on_state"

  create_table "sessions", force: true do |t|
    t.string   "token"
    t.datetime "expiration"
    t.integer  "user_id"
  end

  add_index "sessions", ["expiration"], name: "index_sessions_on_expiration"
  add_index "sessions", ["token"], name: "index_sessions_on_token"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.boolean  "verified"
    t.string   "email_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["email_token"], name: "index_users_on_email_token"

end
