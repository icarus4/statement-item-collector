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

ActiveRecord::Schema.define(version: 20140804032703) do

  create_table "item_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "item_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "statement_item_anc_desc_udx", unique: true
  add_index "item_hierarchies", ["descendant_id"], name: "statement_item_desc_idx"

  create_table "items", force: true do |t|
    t.string   "name",         null: false
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "statement_id"
  end

  add_index "items", ["level"], name: "index_items_on_level"
  add_index "items", ["name"], name: "index_items_on_name"
  add_index "items", ["parent_id"], name: "index_items_on_parent_id"
  add_index "items", ["statement_id"], name: "index_items_on_statement_id"

  create_table "items_statements", id: false, force: true do |t|
    t.integer "statement_id", null: false
    t.integer "item_id",      null: false
  end

  add_index "items_statements", ["item_id", "statement_id"], name: "index_statement_item_id_and_statement_id"
  add_index "items_statements", ["item_id"], name: "index_items_statements_on_item_id"
  add_index "items_statements", ["statement_id", "item_id"], name: "index_statement_id_and_statement_item_id"
  add_index "items_statements", ["statement_id"], name: "index_items_statements_on_statement_id"

  create_table "statements", force: true do |t|
    t.integer  "stock_id",   null: false
    t.integer  "year",       null: false
    t.integer  "quarter",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statements", ["quarter"], name: "index_statements_on_quarter"
  add_index "statements", ["stock_id"], name: "index_statements_on_stock_id"
  add_index "statements", ["year"], name: "index_statements_on_year"

  create_table "stocks", force: true do |t|
    t.string   "ticker",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country",    default: "tw", null: false
  end

  add_index "stocks", ["country"], name: "index_stocks_on_country"
  add_index "stocks", ["ticker"], name: "index_stocks_on_ticker"

end
