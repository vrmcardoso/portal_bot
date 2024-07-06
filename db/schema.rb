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

ActiveRecord::Schema[7.1].define(version: 2024_07_06_204706) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "backtest_trades", force: :cascade do |t|
    t.string "side"
    t.decimal "entry_price"
    t.decimal "exit_price"
    t.datetime "entry_date"
    t.datetime "exit_date"
    t.decimal "quantity"
    t.decimal "profit_loss"
    t.decimal "fees"
    t.integer "trade_duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "backtest_id", null: false
    t.bigint "trading_pair_id", null: false
    t.index ["backtest_id"], name: "index_backtest_trades_on_backtest_id"
    t.index ["trading_pair_id"], name: "index_backtest_trades_on_trading_pair_id"
  end

  create_table "backtests", force: :cascade do |t|
    t.string "strategy"
    t.json "parameters"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal "profit_loss"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paper_trades", force: :cascade do |t|
    t.string "side"
    t.decimal "entry_price"
    t.decimal "exit_price"
    t.datetime "entry_date"
    t.datetime "exit_date"
    t.decimal "quantity"
    t.decimal "profit_loss"
    t.decimal "fees"
    t.integer "trade_duration"
    t.boolean "backtest", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "trading_pair_id", null: false
    t.index ["trading_pair_id"], name: "index_paper_trades_on_trading_pair_id"
  end

  create_table "real_trades", force: :cascade do |t|
    t.string "side"
    t.decimal "entry_price"
    t.decimal "exit_price"
    t.datetime "entry_date"
    t.datetime "exit_date"
    t.decimal "quantity"
    t.decimal "profit_loss"
    t.decimal "fees"
    t.integer "trade_duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "trading_pair_id", null: false
    t.index ["trading_pair_id"], name: "index_real_trades_on_trading_pair_id"
  end

  create_table "trading_pairs", force: :cascade do |t|
    t.string "symbol", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "backtest_trades", "backtests"
  add_foreign_key "backtest_trades", "trading_pairs"
  add_foreign_key "paper_trades", "trading_pairs"
  add_foreign_key "real_trades", "trading_pairs"
end
