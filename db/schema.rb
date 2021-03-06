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

ActiveRecord::Schema.define(version: 20150311222425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approvals", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order_id"
  end

  add_index "approvals", ["order_id"], name: "index_approvals_on_order_id", using: :btree
  add_index "approvals", ["role_id"], name: "index_approvals_on_role_id", using: :btree
  add_index "approvals", ["user_id"], name: "index_approvals_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["order_id"], name: "index_comments_on_order_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "imports", force: :cascade do |t|
    t.string   "catalog_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "quantity",    default: 1
    t.integer  "total_cents", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "site_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",      default: 0, null: false
  end

  add_index "orders", ["site_id"], name: "index_orders_on_site_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "product_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "budget"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_number"
  end

  create_table "products", force: :cascade do |t|
    t.string   "item_id"
    t.string   "description"
    t.string   "measure"
    t.integer  "cost_cents",       default: 0, null: false
    t.integer  "state",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_group_id"
  end

  add_index "products", ["product_group_id"], name: "index_products_on_product_group_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.integer  "code"
    t.string   "abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "google_image_url"
    t.integer  "site_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["site_id"], name: "index_users_on_site_id", using: :btree

  add_foreign_key "approvals", "orders"
  add_foreign_key "approvals", "roles"
  add_foreign_key "approvals", "users"
  add_foreign_key "line_items", "products"
end
