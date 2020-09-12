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

ActiveRecord::Schema.define(version: 2020_09_12_064828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "app_user_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "dao_person_id"
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_person_id"], name: "index_app_user_accounts_on_dao_person_id", unique: true
  end

  create_table "app_user_profiles", force: :cascade do |t|
    t.uuid "app_user_account_id"
    t.string "initials", null: false
    t.string "fgcolor", null: false
    t.string "bgcolor", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["app_user_account_id"], name: "index_app_user_profiles_on_app_user_account_id"
  end

  create_table "dao_acceptance_criteria", force: :cascade do |t|
    t.uuid "dao_pbi_id"
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_pbi_id"], name: "index_dao_acceptance_criteria_on_dao_pbi_id"
  end

  create_table "dao_pbis", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "dao_product_id"
    t.string "status", null: false
    t.string "description", null: false
    t.integer "size"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_product_id"], name: "idx_product_id_on_pbis"
  end

  create_table "dao_people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_dao_people_on_email", unique: true
  end

  create_table "dao_products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.uuid "owner_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dao_release_items", force: :cascade do |t|
    t.uuid "dao_release_id"
    t.uuid "dao_pbi_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_release_id", "dao_pbi_id"], name: "index_dao_release_items_on_dao_release_id_and_dao_pbi_id", unique: true
  end

  create_table "dao_releases", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "dao_product_id"
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_product_id"], name: "index_dao_releases_on_dao_product_id"
  end

  create_table "dao_team_members", force: :cascade do |t|
    t.uuid "dao_team_id"
    t.uuid "dao_person_id"
    t.string "role", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_team_id", "dao_person_id"], name: "index_dao_team_members_on_dao_team_id_and_dao_person_id", unique: true
    t.index ["dao_team_id"], name: "index_dao_team_members_on_dao_team_id"
  end

  create_table "dao_teams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "dao_product_id"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dao_product_id"], name: "index_dao_teams_on_dao_product_id"
  end

  add_foreign_key "app_user_accounts", "dao_people"
  add_foreign_key "app_user_profiles", "app_user_accounts"
  add_foreign_key "dao_acceptance_criteria", "dao_pbis"
  add_foreign_key "dao_pbis", "dao_products"
  add_foreign_key "dao_products", "dao_people", column: "owner_id"
  add_foreign_key "dao_release_items", "dao_pbis"
  add_foreign_key "dao_release_items", "dao_releases"
  add_foreign_key "dao_releases", "dao_products"
  add_foreign_key "dao_team_members", "dao_teams"
  add_foreign_key "dao_teams", "dao_products"
end
