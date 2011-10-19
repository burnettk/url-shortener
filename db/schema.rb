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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110528214117) do

  create_table "link_visits", :force => true do |t|
    t.integer  "link_id",    :null => false
    t.integer  "user_id",    :null => false
    t.string   "path",       :null => false
    t.datetime "created_at"
  end

  add_index "link_visits", ["created_at"], :name => "index_link_visits_on_created_at"
  add_index "link_visits", ["link_id"], :name => "link_visits_ibfk_link_id"
  add_index "link_visits", ["path"], :name => "index_link_visits_on_path"
  add_index "link_visits", ["user_id"], :name => "link_visits_ibfk_user_id"

  create_table "links", :force => true do |t|
    t.string   "shortcut",                     :null => false
    t.string   "url",                          :null => false
    t.boolean  "active",     :default => true, :null => false
    t.integer  "user_id",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["created_at"], :name => "index_links_on_created_at"
  add_index "links", ["shortcut"], :name => "index_links_on_shortcut", :unique => true
  add_index "links", ["user_id"], :name => "links_ibfk_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "identifier",                  :null => false
    t.string   "active_directory_objectguid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["active_directory_objectguid"], :name => "index_users_on_active_directory_objectguid", :unique => true
  add_index "users", ["identifier"], :name => "index_users_on_identifier", :unique => true

end
