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

ActiveRecord::Schema.define(version: 20150525143519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogs", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
  end

  add_index "blogs", ["project_id"], name: "index_blogs_on_project_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "blog_id"
    t.integer  "user_id"
  end

  add_index "comments", ["blog_id"], name: "index_comments_on_blog_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "donations", force: :cascade do |t|
    t.integer  "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
    t.integer  "user_id"
    t.boolean  "paid"
  end

  add_index "donations", ["project_id"], name: "index_donations_on_project_id", using: :btree
  add_index "donations", ["user_id"], name: "index_donations_on_user_id", using: :btree

  create_table "followers", force: :cascade do |t|
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "followers", ["project_id"], name: "index_followers_on_project_id", using: :btree
  add_index "followers", ["user_id"], name: "index_followers_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "goal"
    t.datetime "expiration_date"
    t.string   "sector"
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "address"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "video_url"
    t.string   "emailed"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "username"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "blogs", "projects"
  add_foreign_key "comments", "blogs"
  add_foreign_key "comments", "users"
  add_foreign_key "donations", "projects"
  add_foreign_key "donations", "users"
  add_foreign_key "followers", "projects"
  add_foreign_key "followers", "users"
  add_foreign_key "projects", "users"
end
