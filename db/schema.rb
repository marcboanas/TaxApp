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

ActiveRecord::Schema.define(version: 20150507111022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "email_verification"
    t.string   "verification_code"
    t.string   "api_authtoken"
    t.datetime "authtoken_expiry"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.datetime "reset_sent_at"
    t.string   "reset_digest"
    t.datetime "activated_at"
    t.boolean  "activated"
    t.boolean  "admin"
    t.string   "activation_digest"
    t.string   "remember_digest"
  end

end
