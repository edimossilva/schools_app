# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_20_132617) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devise_api_tokens", force: :cascade do |t|
    t.string "resource_owner_type", null: false
    t.bigint "resource_owner_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token"
    t.integer "expires_in", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_devise_api_tokens_on_access_token"
    t.index ["previous_refresh_token"], name: "index_devise_api_tokens_on_previous_refresh_token"
    t.index ["refresh_token"], name: "index_devise_api_tokens_on_refresh_token"
    t.index ["resource_owner_type", "resource_owner_id"], name: "index_devise_api_tokens_on_resource_owner"
  end

  create_table "school_searches", force: :cascade do |t|
    t.bigint "search_school_param_id", null: false
    t.bigint "school_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["school_id"], name: "index_school_searches_on_school_id"
    t.index ["search_school_param_id"], name: "index_school_searches_on_search_school_param_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "external_id", null: false
    t.string "lat", null: false
    t.string "lng", null: false
    t.jsonb "payload", default: {}
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_schools_on_external_id", unique: true
  end

  create_table "search_school_params", force: :cascade do |t|
    t.string "params_as_key", null: false
    t.jsonb "params"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["params_as_key"], name: "index_search_school_params_on_params_as_key", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "oauth_provider"
    t.string "oauth_uid"
    t.boolean "admin", default: false, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "school_searches", "schools"
  add_foreign_key "school_searches", "search_school_params"
end
