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

ActiveRecord::Schema.define(version: 20180410195456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bots", force: :cascade do |t|
    t.bigint "developer_id"
    t.string "bot_name"
    t.text "bot_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
    t.text "bot_tags", default: [], array: true
    t.string "current_version"
    t.text "eth_address"
    t.text "hashed_identifier"
    t.text "metadata_url"
    t.text "developer_eth_address"
    t.index ["developer_id"], name: "index_bots_on_developer_id"
  end

  create_table "developer_records", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "street_1"
    t.string "street_2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.string "phone"
    t.string "phone_ext"
    t.string "email"
    t.string "url"
    t.boolean "approved", default: false
    t.text "eth_address"
    t.text "hashed_identifier"
    t.text "metadata_url"
  end

  create_table "developers", force: :cascade do |t|
    t.bigint "developer_record_id"
    t.text "eth_address"
    t.boolean "owner", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ethereum_transactions", force: :cascade do |t|
    t.text "tx_hash"
    t.integer "ownerable_id"
    t.string "ownerable_type"
    t.string "action_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
