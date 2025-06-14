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

ActiveRecord::Schema[7.1].define(version: 2025_06_14_184652) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_balances", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "balance", precision: 20, scale: 2, null: false
    t.datetime "recorded_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "recorded_at"], name: "index_account_balances_on_account_id_and_recorded_at"
    t.index ["account_id"], name: "index_account_balances_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "account_type", null: false
    t.string "currency", default: "CAD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_type"], name: "index_accounts_on_account_type"
  end

  create_table "holdings", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "symbol", null: false
    t.decimal "quantity", precision: 20, scale: 6, null: false
    t.decimal "average_price", precision: 20, scale: 4, null: false
    t.decimal "current_price", precision: 20, scale: 4, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "symbol"], name: "index_holdings_on_account_id_and_symbol", unique: true
    t.index ["account_id"], name: "index_holdings_on_account_id"
    t.index ["symbol"], name: "index_holdings_on_symbol"
  end

  add_foreign_key "account_balances", "accounts", on_delete: :cascade
  add_foreign_key "holdings", "accounts", on_delete: :cascade
end
