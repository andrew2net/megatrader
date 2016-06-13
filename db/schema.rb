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

ActiveRecord::Schema.define(version: 20160612183542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                           null: false
    t.string   "crypted_password",                null: false
    t.string   "password_salt",                   null: false
    t.string   "persistence_token",               null: false
    t.string   "single_access_token",             null: false
    t.string   "perishable_token",                null: false
    t.integer  "login_count",         default: 0, null: false
    t.integer  "failed_login_count",  default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "admins_roles", force: :cascade do |t|
    t.integer "admin_id"
    t.integer "role_id"
  end

  add_index "admins_roles", ["admin_id"], name: "index_admins_roles_on_admin_id", using: :btree
  add_index "admins_roles", ["role_id"], name: "index_admins_roles_on_role_id", using: :btree

  create_table "correlations", force: :cascade do |t|
    t.integer  "row_tool_symbol_id"
    t.integer  "col_tool_symbol_id"
    t.decimal  "value",              precision: 3, scale: 2
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "time_frame_id"
  end

  add_index "correlations", ["col_tool_symbol_id"], name: "index_correlations_on_col_tool_symbol_id", using: :btree
  add_index "correlations", ["row_tool_symbol_id"], name: "index_correlations_on_row_tool_symbol_id", using: :btree
  add_index "correlations", ["time_frame_id"], name: "correlation_pair_unique_idx", unique: true, using: :btree
  add_index "correlations", ["time_frame_id"], name: "index_correlations_on_time_frame_id", using: :btree

  create_table "menu_item_translations", force: :cascade do |t|
    t.integer  "menu_item_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "title",        null: false
  end

  add_index "menu_item_translations", ["locale"], name: "index_menu_item_translations_on_locale", using: :btree
  add_index "menu_item_translations", ["menu_item_id"], name: "index_menu_item_translations_on_menu_item_id", using: :btree

  create_table "menu_items", force: :cascade do |t|
    t.integer  "type_id",    null: false
    t.integer  "page_id"
    t.integer  "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "parent"
  end

  add_index "menu_items", ["parent"], name: "index_menu_items_on_parent", using: :btree

  create_table "page_translations", force: :cascade do |t|
    t.integer  "page_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.string   "url"
    t.text     "text"
    t.string   "keywords"
    t.string   "description"
  end

  add_index "page_translations", ["locale"], name: "index_page_translations_on_locale", using: :btree
  add_index "page_translations", ["page_id"], name: "index_page_translations_on_page_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.integer  "type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pairs", force: :cascade do |t|
    t.integer  "time_frame_id"
    t.integer  "tool_symbol_1_id"
    t.integer  "tool_symbol_2_id"
    t.decimal  "weight_1",         precision: 7, scale: 2
    t.decimal  "weight_2",         precision: 7, scale: 2
    t.decimal  "fitness",          precision: 3
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "pairs", ["time_frame_id"], name: "index_pairs_on_time_frame_id", using: :btree
  add_index "pairs", ["time_frame_id"], name: "pair_unique_idx", unique: true, using: :btree
  add_index "pairs", ["tool_symbol_1_id"], name: "index_pairs_on_tool_symbol_1_id", using: :btree
  add_index "pairs", ["tool_symbol_2_id"], name: "index_pairs_on_tool_symbol_2_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spreads", force: :cascade do |t|
    t.integer  "tool_symbol_id"
    t.integer  "time_frame_id"
    t.float    "value"
    t.datetime "date_time"
  end

  add_index "spreads", ["date_time", "time_frame_id", "tool_symbol_id"], name: "index_spreads_on_date_time_and_time_frame_id_and_tool_symbol_id", unique: true, using: :btree
  add_index "spreads", ["time_frame_id"], name: "index_spreads_on_time_frame_id", using: :btree
  add_index "spreads", ["tool_symbol_id"], name: "index_spreads_on_tool_symbol_id", using: :btree

  create_table "time_frames", force: :cascade do |t|
    t.string   "name",       limit: 3
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "tool_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tool_symbols", force: :cascade do |t|
    t.string   "name",          limit: 10
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "full_name"
    t.integer  "tool_group_id"
  end

  add_index "tool_symbols", ["name"], name: "index_tool_symbols_on_name", unique: true, using: :btree
  add_index "tool_symbols", ["tool_group_id"], name: "index_tool_symbols_on_tool_group_id", using: :btree

  add_foreign_key "correlations", "time_frames"
  add_foreign_key "pairs", "time_frames"
  add_foreign_key "pairs", "tool_symbols", column: "tool_symbol_1_id"
  add_foreign_key "pairs", "tool_symbols", column: "tool_symbol_2_id"
  add_foreign_key "spreads", "time_frames"
  add_foreign_key "spreads", "tool_symbols"
end
