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

ActiveRecord::Schema[7.1].define(version: 2024_11_28_184525) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "articles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "unpublished"
    t.string "title"
  end

  create_table "comments", force: :cascade do |t|
    t.string "author"
    t.text "body"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investments", force: :cascade do |t|
    t.bigint "investor_id", null: false
    t.bigint "offering_id", null: false
    t.decimal "amount"
    t.datetime "signed_at"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["investor_id"], name: "index_investments_on_investor_id"
    t.index ["offering_id"], name: "index_investments_on_offering_id"
  end

  create_table "investors", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "kyc_verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kyc_status", default: 0
    t.index ["user_id"], name: "index_investors_on_user_id"
  end

  create_table "offerings", force: :cascade do |t|
    t.string "type"
    t.string "state"
    t.string "name"
    t.integer "min_invest_amount"
    t.integer "min_target"
    t.integer "max_target"
    t.integer "total_investors"
    t.integer "current_reserved_amount"
    t.integer "funded_amount"
    t.integer "reserved_investors"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "target_amount"
    t.boolean "can_advance_state"
    t.integer "status", default: 0
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user"
  end

  add_foreign_key "investments", "investors"
  add_foreign_key "investments", "offerings"
  add_foreign_key "investors", "users"
end
