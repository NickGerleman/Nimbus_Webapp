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

ActiveRecord::Schema.define(version: 20130731071128) do

  create_table "connections", force: true do |t|
    t.string   "type"
    t.string   "state"
    t.text     "session"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       default: "Unnamed Connection"
    t.datetime "expires_at", default: '2013-07-31 14:28:55'
  end

  add_index "connections", ["expires_at"], name: "index_connections_on_expires_at"

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
    t.string   "password_reset_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["email_token"], name: "index_users_on_email_token"
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token"

end
