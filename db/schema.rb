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

ActiveRecord::Schema.define(version: 20150413015250) do

  create_table "commodities", force: :cascade do |t|
    t.string "code",        limit: 2,     null: false
    t.text   "description", limit: 65535
  end

  add_index "commodities", ["code"], name: "index_commodities_on_code", unique: true, using: :btree

  create_table "countries", force: :cascade do |t|
    t.string "code",    limit: 4,   null: false
    t.string "country", limit: 255, null: false
  end

  add_index "countries", ["code"], name: "index_countries_on_code", unique: true, using: :btree

  create_table "modes", force: :cascade do |t|
    t.string "code",        limit: 1,     null: false
    t.text   "description", limit: 65535
  end

  add_index "modes", ["code"], name: "index_modes_on_code", unique: true, using: :btree

  create_table "ports", force: :cascade do |t|
    t.string  "code",      limit: 4,   null: false
    t.string  "name",      limit: 255
    t.integer "port_type", limit: 4
  end

  create_table "states", force: :cascade do |t|
    t.integer "country_id", limit: 4,   null: false
    t.string  "code",       limit: 2
    t.string  "name",       limit: 255
  end

  create_table "trades", force: :cascade do |t|
    t.integer  "trade_type",      limit: 4,                                        null: false
    t.integer  "country_id",      limit: 4,                                        null: false
    t.integer  "usa_state_id",    limit: 4
    t.integer  "port_id",         limit: 4
    t.integer  "mode_id",         limit: 4,                                        null: false
    t.integer  "state_id",        limit: 4
    t.integer  "commodity_id",    limit: 4
    t.decimal  "value",                     precision: 13, scale: 2, default: 0.0
    t.decimal  "shipwt",                    precision: 13, scale: 2, default: 0.0
    t.decimal  "freight_charges",           precision: 13, scale: 2, default: 0.0
    t.integer  "df",              limit: 4
    t.boolean  "containerized",   limit: 1
    t.date     "date"
    t.integer  "table_type",      limit: 4
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  create_table "usa_states", force: :cascade do |t|
    t.string "code", limit: 2,   null: false
    t.string "name", limit: 255
  end

end
