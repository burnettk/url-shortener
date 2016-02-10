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

ActiveRecord::Schema.define(version: 20130309173334) do

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "shortcut_visits", force: :cascade do |t|
    t.integer  "shortcut_id", limit: 4,   null: false
    t.integer  "user_id",     limit: 4,   null: false
    t.string   "path",        limit: 255, null: false
    t.datetime "created_at"
  end

  add_index "shortcut_visits", ["created_at"], name: "index_shortcut_visits_on_created_at", using: :btree
  add_index "shortcut_visits", ["path"], name: "index_shortcut_visits_on_path", using: :btree
  add_index "shortcut_visits", ["shortcut_id"], name: "shortcut_visits_ibfk_shortcut_id", using: :btree
  add_index "shortcut_visits", ["user_id"], name: "shortcut_visits_ibfk_user_id", using: :btree

  create_table "shortcuts", force: :cascade do |t|
    t.string   "shortcut",           limit: 255, null: false
    t.string   "url",                limit: 255, null: false
    t.datetime "deleted_at"
    t.integer  "created_by_user_id", limit: 4,   null: false
    t.integer  "updated_by_user_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shortcuts", ["created_at"], name: "index_shortcuts_on_created_at", using: :btree
  add_index "shortcuts", ["created_by_user_id"], name: "shortcuts_ibfk_created_by_user_id", using: :btree
  add_index "shortcuts", ["shortcut"], name: "index_shortcuts_on_shortcut", unique: true, using: :btree
  add_index "shortcuts", ["updated_by_user_id"], name: "shortcuts_ibfk_updated_by_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "identifier",                  limit: 255, null: false
    t.string   "active_directory_objectguid", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["active_directory_objectguid"], name: "index_users_on_active_directory_objectguid", unique: true, using: :btree
  add_index "users", ["identifier"], name: "index_users_on_identifier", unique: true, using: :btree

  add_foreign_key "shortcut_visits", "shortcuts", name: "shortcut_visits_ibfk_shortcut_id"
  add_foreign_key "shortcut_visits", "users", name: "shortcut_visits_ibfk_user_id"
  add_foreign_key "shortcuts", "users", column: "created_by_user_id", name: "shortcuts_ibfk_created_by_user_id"
  add_foreign_key "shortcuts", "users", column: "updated_by_user_id", name: "shortcuts_ibfk_updated_by_user_id"
end
