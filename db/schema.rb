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

ActiveRecord::Schema.define(version: 20141120043809) do

  create_table "item_hierarchies", id: false, force: true do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "item_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "statement_item_anc_desc_udx", unique: true
  add_index "item_hierarchies", ["descendant_id"], name: "statement_item_desc_idx"

  create_table "item_standard_item_pairs", force: true do |t|
    t.integer "standard_item_id",   null: false
    t.integer "item_id",            null: false
    t.boolean "is_exactly_matched"
  end

  add_index "item_standard_item_pairs", ["standard_item_id", "item_id", "is_exactly_matched"], name: "index_item_standard_item_pairs"

  create_table "item_standard_item_statement_pairs", force: true do |t|
    t.integer "item_id",            null: false
    t.integer "standard_item_id",   null: false
    t.integer "statement_id",       null: false
    t.boolean "is_exactly_matched"
  end

  add_index "item_standard_item_statement_pairs", ["is_exactly_matched"], name: "index_item_standard_item_statement_pairs_on_is_exactly_matched"
  add_index "item_standard_item_statement_pairs", ["item_id", "standard_item_id", "statement_id", "is_exactly_matched"], name: "index_item_standard_item_statement_pairs"
  add_index "item_standard_item_statement_pairs", ["item_id"], name: "index_item_standard_item_statement_pairs_on_item_id"
  add_index "item_standard_item_statement_pairs", ["standard_item_id"], name: "index_item_standard_item_statement_pairs_on_standard_item_id"
  add_index "item_standard_item_statement_pairs", ["statement_id"], name: "index_item_standard_item_statement_pairs_on_statement_id"

  create_table "item_statement_pairs", force: true do |t|
    t.integer "item_id",      null: false
    t.integer "statement_id", null: false
  end

  add_index "item_statement_pairs", ["item_id", "statement_id"], name: "index_item_statement_pairs_on_item_id_and_statement_id", unique: true
  add_index "item_statement_pairs", ["statement_id"], name: "index_item_statement_pairs_on_statement_id"

  create_table "item_stock_pairs", force: true do |t|
    t.integer "item_id",  null: false
    t.integer "stock_id", null: false
  end

  add_index "item_stock_pairs", ["item_id", "stock_id"], name: "index_item_stock_pairs_on_item_id_and_stock_id", unique: true
  add_index "item_stock_pairs", ["stock_id"], name: "index_item_stock_pairs_on_stock_id"

  create_table "items", force: true do |t|
    t.string   "name",                         null: false
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.boolean  "has_value"
    t.integer  "previous_id"
    t.integer  "next_id"
    t.string   "s_type"
    t.string   "namespace"
    t.integer  "stocks_count",     default: 0
    t.integer  "statements_count", default: 0
  end

  add_index "items", ["has_value"], name: "index_items_on_has_value"
  add_index "items", ["level"], name: "index_items_on_level"
  add_index "items", ["name"], name: "index_items_on_name"
  add_index "items", ["next_id"], name: "index_items_on_next_id"
  add_index "items", ["parent_id"], name: "index_items_on_parent_id"
  add_index "items", ["previous_id"], name: "index_items_on_previous_id"
  add_index "items", ["s_type"], name: "index_items_on_s_type"

  create_table "si_xbrl_mappings", force: true do |t|
    t.integer  "standard_item_id"
    t.string   "xbrl_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standard_items", force: true do |t|
    t.string   "name"
    t.string   "chinese_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "standard_items", ["chinese_name"], name: "index_standard_items_on_chinese_name"
  add_index "standard_items", ["name"], name: "index_standard_items_on_name"

  create_table "statements", force: true do |t|
    t.integer  "stock_id",                null: false
    t.integer  "year",                    null: false
    t.integer  "quarter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "s_type"
    t.date     "end_date"
    t.integer  "items_count", default: 0
  end

  add_index "statements", ["quarter"], name: "index_statements_on_quarter"
  add_index "statements", ["s_type"], name: "index_statements_on_s_type"
  add_index "statements", ["stock_id"], name: "index_statements_on_stock_id"
  add_index "statements", ["year"], name: "index_statements_on_year"

  create_table "stocks", force: true do |t|
    t.string   "ticker",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country",      default: "tw", null: false
    t.string   "category"
    t.string   "sub_category"
    t.integer  "items_count",  default: 0
  end

  add_index "stocks", ["category"], name: "index_stocks_on_category"
  add_index "stocks", ["country"], name: "index_stocks_on_country"
  add_index "stocks", ["sub_category"], name: "index_stocks_on_sub_category"
  add_index "stocks", ["ticker"], name: "index_stocks_on_ticker"

  create_table "value_comparisons", force: true do |t|
    t.integer  "standard_item_id"
    t.integer  "statement_id"
    t.integer  "gfs_value"
    t.integer  "xbrl_value"
    t.integer  "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "value_comparisons", ["result"], name: "index_value_comparisons_on_result"
  add_index "value_comparisons", ["standard_item_id"], name: "index_value_comparisons_on_standard_item_id"
  add_index "value_comparisons", ["statement_id"], name: "index_value_comparisons_on_statement_id"

end
