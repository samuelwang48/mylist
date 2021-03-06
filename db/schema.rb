# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110516023840) do

  create_table "contact_fields", :force => true do |t|
    t.integer  "contact_id"
    t.text     "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "ftype"
  end

  create_table "contact_groups", :force => true do |t|
    t.integer  "user_id"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "contact_groups_relations", :force => true do |t|
    t.integer  "contact_id"
    t.integer  "contact_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "local_user_id"
    t.text     "firstname"
    t.text     "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "user_id"
    t.string   "image_type"
    t.string   "path"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "invitation_type"
    t.text     "token"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",          :default => 1
  end

  create_table "items", :force => true do |t|
    t.text     "description"
    t.boolean  "is_finished", :default => false
    t.integer  "todo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort"
    t.datetime "deleted_at"
    t.datetime "start"
    t.datetime "due"
    t.integer  "predecessor"
  end

  create_table "reminders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.integer  "item_id"
    t.text     "event"
    t.boolean  "method_phone_def", :default => false
    t.boolean  "method_email_def", :default => false
    t.boolean  "method_email_alt", :default => false
    t.datetime "occurence"
    t.integer  "seconds_before"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "site_logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "local_user_id"
    t.integer  "todo_id"
    t.integer  "saved_todo_id"
    t.integer  "item_id"
    t.integer  "reminder_id"
    t.integer  "contact_id"
    t.integer  "todo_permission_id"
    t.integer  "tracking_id"
    t.text     "log_type"
    t.text     "ip"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_permissions", :force => true do |t|
    t.integer  "todo_id"
    t.integer  "contact_id"
    t.boolean  "r",          :default => false
    t.boolean  "w",          :default => false
    t.boolean  "d",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "todos", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "data"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "saved_from",  :default => 0
    t.integer  "reads",       :default => 0
    t.datetime "modified_at"
  end

  create_table "trackings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "todo_id"
    t.integer  "todo_user_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "accepted"
    t.integer  "init_user_id"
    t.text     "message"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_todo_id"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "country"
    t.string   "phone_mobile"
    t.string   "email_alt"
    t.boolean  "searchable",      :default => true
    t.integer  "profile_visible", :default => 1
    t.string   "url"
    t.string   "position"
    t.string   "occupation"
    t.integer  "sex"
    t.datetime "deleted_at"
    t.string   "activation_code"
    t.integer  "status",          :default => 0
    t.text     "bio"
    t.string   "birthday"
    t.integer  "login_times",     :default => 0
    t.string   "remember_me"
  end

end
