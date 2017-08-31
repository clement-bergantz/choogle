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

ActiveRecord::Schema.define(version: 20170830093547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "choogles", force: :cascade do |t|
    t.string   "title"
    t.datetime "due_at"
    t.datetime "happens_at"
    t.string   "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.index ["user_id"], name: "index_choogles_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "choogle_id"
    t.index ["choogle_id"], name: "index_comments_on_choogle_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "choogle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["choogle_id"], name: "index_notifications_on_choogle_id", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "api_google_id"
    t.float    "rating"
  end

  create_table "proposal_tags", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "proposal_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["proposal_id"], name: "index_proposal_tags_on_proposal_id", using: :btree
    t.index ["tag_id"], name: "index_proposal_tags_on_tag_id", using: :btree
  end

  create_table "proposals", force: :cascade do |t|
    t.integer  "choogle_id"
    t.integer  "place_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["choogle_id"], name: "index_proposals_on_choogle_id", using: :btree
    t.index ["place_id"], name: "index_proposals_on_place_id", using: :btree
    t.index ["user_id"], name: "index_proposals_on_user_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "upvotes", force: :cascade do |t|
    t.integer  "proposal_id"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["proposal_id"], name: "index_upvotes_on_proposal_id", using: :btree
    t.index ["user_id"], name: "index_upvotes_on_user_id", using: :btree
  end

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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_picture_url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "token"
    t.datetime "token_expiry"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "choogles", "users"
  add_foreign_key "comments", "choogles"
  add_foreign_key "comments", "users"
  add_foreign_key "notifications", "choogles"
  add_foreign_key "notifications", "users"
  add_foreign_key "proposal_tags", "proposals"
  add_foreign_key "proposal_tags", "tags"
  add_foreign_key "proposals", "choogles"
  add_foreign_key "proposals", "places"
  add_foreign_key "proposals", "users"
  add_foreign_key "upvotes", "proposals"
  add_foreign_key "upvotes", "users"
end
