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

ActiveRecord::Schema[7.0].define(version: 2022_03_31_003647) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "crms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "entity"
    t.string "name"
    t.json "oauth"
    t.boolean "status", default: false
    t.datetime "expire_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_crms_on_status"
    t.index ["user_id", "entity"], name: "index_crms_on_user_id_and_entity", unique: true
    t.index ["user_id"], name: "index_crms_on_user_id"
  end

  create_table "model_has_permissions", force: :cascade do |t|
    t.bigint "permission_id", null: false
    t.string "model_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_type"], name: "index_model_has_permissions_on_model_type"
    t.index ["permission_id"], name: "index_model_has_permissions_on_permission_id"
  end

  create_table "model_has_roles", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.string "model_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["model_type"], name: "index_model_has_roles_on_model_type"
    t.index ["role_id"], name: "index_model_has_roles_on_role_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_permissions_on_name"
  end

  create_table "properties", force: :cascade do |t|
    t.bigint "prospect_id", null: false
    t.string "field_name"
    t.string "field_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_name"], name: "index_properties_on_field_name"
    t.index ["field_value"], name: "index_properties_on_field_value"
    t.index ["prospect_id"], name: "index_properties_on_prospect_id"
  end

  create_table "prospects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "crm_id", null: false
    t.string "entity"
    t.string "name"
    t.string "uid"
    t.string "profile_url"
    t.string "picture_url"
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crm_id"], name: "index_prospects_on_crm_id"
    t.index ["entity"], name: "index_prospects_on_entity"
    t.index ["name"], name: "index_prospects_on_name"
    t.index ["status"], name: "index_prospects_on_status"
    t.index ["user_id", "crm_id", "uid"], name: "index_prospects_on_user_id_and_crm_id_and_uid", unique: true
    t.index ["user_id"], name: "index_prospects_on_user_id"
  end

  create_table "role_has_permissions", force: :cascade do |t|
    t.bigint "permission_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_has_permissions_on_permission_id"
    t.index ["role_id"], name: "index_role_has_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "searches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "entity"
    t.json "oauth"
    t.boolean "status", default: true
    t.datetime "expire_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity"], name: "index_searches_on_entity"
    t.index ["status"], name: "index_searches_on_status"
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "phone"
    t.string "address"
    t.string "address_number"
    t.string "city"
    t.string "provice_state"
    t.string "portal_code"
    t.string "country"
    t.boolean "sign_in_twofa", default: false
    t.string "twofa_code"
    t.string "twofa_code_token"
    t.datetime "twofa_code_at"
    t.string "password_token"
    t.datetime "password_sent_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["password_token"], name: "index_users_on_password_token"
  end

  add_foreign_key "crms", "users"
  add_foreign_key "model_has_permissions", "permissions"
  add_foreign_key "model_has_roles", "roles"
  add_foreign_key "properties", "prospects"
  add_foreign_key "prospects", "crms"
  add_foreign_key "prospects", "users"
  add_foreign_key "role_has_permissions", "permissions"
  add_foreign_key "role_has_permissions", "roles"
  add_foreign_key "searches", "users"
end
