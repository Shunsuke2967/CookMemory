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

ActiveRecord::Schema.define(version: 2021_11_08_085421) do

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "hashed", null: false
    t.string "salt", null: false
    t.index ["name"], name: "index_accounts_on_name", unique: true
  end

  create_table "contents", force: :cascade do |t|
    t.string "title"
    t.string "post_content"
    t.string "imgfile"
    t.integer "account_id"
    t.index ["account_id"], name: "index_contents_on_account_id"
  end

  add_foreign_key "contents", "accounts"
end
