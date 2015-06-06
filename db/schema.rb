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

ActiveRecord::Schema.define(version: 20150606040248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campus_ballots", force: :cascade do |t|
    t.integer  "showtime_id", null: false
    t.datetime "expires_at",  null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "campus_ballots", ["expires_at"], name: "index_campus_ballots_on_expires_at", using: :btree
  add_index "campus_ballots", ["showtime_id"], name: "index_campus_ballots_on_showtime_id", unique: true, using: :btree

  create_table "campus_votes", force: :cascade do |t|
    t.integer  "ballot_id",                        null: false
    t.integer  "user_id",                          null: false
    t.integer  "university_id",                    null: false
    t.boolean  "vote_for_own_uni", default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "campus_votes", ["ballot_id", "user_id"], name: "index_campus_votes_on_ballot_id_and_user_id", unique: true, using: :btree
  add_index "campus_votes", ["ballot_id"], name: "index_campus_votes_on_ballot_id", using: :btree
  add_index "campus_votes", ["university_id"], name: "index_campus_votes_on_university_id", using: :btree
  add_index "campus_votes", ["user_id"], name: "index_campus_votes_on_user_id", using: :btree
  add_index "campus_votes", ["vote_for_own_uni"], name: "index_campus_votes_on_vote_for_own_uni", using: :btree

  create_table "enrollments", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "showtime_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "enrollments", ["created_at"], name: "index_enrollments_on_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "enrollments", ["showtime_id"], name: "index_enrollments_on_showtime_id", using: :btree
  add_index "enrollments", ["user_id"], name: "index_enrollments_on_user_id", using: :btree

  create_table "shows", force: :cascade do |t|
    t.string   "name",        null: false
    t.string   "category"
    t.text     "description"
    t.integer  "proposer_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "shows", ["created_at"], name: "index_shows_on_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "shows", ["proposer_id"], name: "index_shows_on_proposer_id", using: :btree

  create_table "showtimes", force: :cascade do |t|
    t.integer  "show_id",                     null: false
    t.string   "title",                       null: false
    t.text     "description"
    t.datetime "starts_at",                   null: false
    t.datetime "ends_at",                     null: false
    t.boolean  "ongoing",     default: true
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "enrollable",  default: false
  end

  add_index "showtimes", ["created_at"], name: "index_showtimes_on_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "showtimes", ["ends_at"], name: "index_showtimes_on_ends_at", using: :btree
  add_index "showtimes", ["enrollable"], name: "index_showtimes_on_enrollable", using: :btree
  add_index "showtimes", ["ongoing"], name: "index_showtimes_on_ongoing", using: :btree
  add_index "showtimes", ["show_id"], name: "index_showtimes_on_show_id", using: :btree
  add_index "showtimes", ["starts_at"], name: "index_showtimes_on_starts_at", using: :btree

  create_table "universities", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "city",       null: false
    t.string   "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "username",               default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.boolean  "admin",                  default: false, null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "bio",                    default: ""
    t.integer  "coins",                  default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "gender"
    t.string   "province"
    t.string   "city"
    t.string   "country"
    t.string   "wechat_headimgurl"
  end

  add_index "users", ["admin"], name: "index_users_on_admin", using: :btree
  add_index "users", ["city"], name: "index_users_on_city", using: :btree
  add_index "users", ["country"], name: "index_users_on_country", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["gender"], name: "index_users_on_gender", using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["province"], name: "index_users_on_province", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "campus_ballots", "showtimes"
  add_foreign_key "campus_votes", "campus_ballots", column: "ballot_id"
  add_foreign_key "campus_votes", "universities"
  add_foreign_key "campus_votes", "users"
  add_foreign_key "enrollments", "showtimes"
  add_foreign_key "enrollments", "users"
  add_foreign_key "shows", "users", column: "proposer_id"
  add_foreign_key "showtimes", "shows"
end
