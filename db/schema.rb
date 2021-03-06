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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121019165608) do

  create_table "loseweights", :force => true do |t|
    t.string   "weight"
    t.string   "hipline"
    t.string   "legline"
    t.date     "update_date"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.text     "remark",       :limit => 255
    t.datetime "gmt_create"
    t.datetime "gmt_modified"
    t.integer  "user_id"
  end

  create_table "qqusers", :force => true do |t|
    t.string   "open_id"
    t.string   "name"
    t.string   "token"
    t.date     "gmt_created"
    t.date     "gmt_modified"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "open_id"
    t.string   "email"
    t.string   "phone"
    t.string   "name"
    t.string   "remark"
    t.string   "status"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
