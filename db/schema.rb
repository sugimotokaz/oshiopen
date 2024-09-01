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

ActiveRecord::Schema[7.1].define(version: 2024_08_30_132042) do
  create_table "oshi_details", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "reason_for_favorite"
    t.text "trigger_for_favorite"
    t.text "activity_history"
    t.bigint "profile_id", null: false
    t.bigint "oshi_name_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "oshi_image"
    t.index ["oshi_name_id"], name: "index_oshi_details_on_oshi_name_id"
    t.index ["profile_id"], name: "index_oshi_details_on_profile_id"
  end

  create_table "oshi_names", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_oshi_names_on_name", unique: true
  end

  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_image"
    t.integer "gender", default: 0, null: false
    t.integer "birth_year"
    t.text "self_introduction"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "oshi_details", "oshi_names"
  add_foreign_key "oshi_details", "profiles"
  add_foreign_key "profiles", "users"
end
