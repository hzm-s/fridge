# typed: false
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_22_123744) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "app_avatars", force: :cascade do |t|
    t.uuid "dao_user_id"
    t.string "bg", null: false
    t.string "fg", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_user_id"], name: "index_app_avatars_on_dao_user_id", unique: true
  end

  create_table "app_oauth_accounts", force: :cascade do |t|
    t.uuid "dao_user_id"
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_user_id"], name: "index_app_oauth_accounts_on_dao_user_id", unique: true
  end

  create_table "dao_acceptance_criteria", force: :cascade do |t|
    t.uuid "dao_product_backlog_item_id"
    t.integer "no", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_product_backlog_item_id", "no"], name: "index_pbi_id_and_no_on_ac", unique: true
  end

  create_table "dao_product_backlog_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "dao_product_id"
    t.string "status", null: false
    t.string "content", null: false
    t.integer "size"
    t.integer "next_acceptance_criterion_no", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_product_id"], name: "idx_product_id_on_pbis"
  end

  create_table "dao_product_backlogs", force: :cascade do |t|
    t.uuid "dao_product_id"
    t.uuid "product_backlog_item_ids", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_product_id"], name: "idx_product_id_on_blo"
  end

  create_table "dao_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dao_team_members", force: :cascade do |t|
    t.uuid "dao_product_id"
    t.uuid "dao_user_id"
    t.string "role", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_product_id", "dao_user_id"], name: "index_dao_team_members_on_dao_product_id_and_dao_user_id", unique: true
  end

  create_table "dao_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "initials", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_dao_users_on_email", unique: true
  end

  add_foreign_key "app_avatars", "dao_users"
  add_foreign_key "app_oauth_accounts", "dao_users"
  add_foreign_key "dao_acceptance_criteria", "dao_product_backlog_items"
  add_foreign_key "dao_product_backlog_items", "dao_products"
  add_foreign_key "dao_product_backlogs", "dao_products"
  add_foreign_key "dao_team_members", "dao_products"
  add_foreign_key "dao_team_members", "dao_users"
end
