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

ActiveRecord::Schema.define(version: 20140729092140) do

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
    t.string   "ticker",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
