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

ActiveRecord::Schema[7.1].define(version: 2024_06_12_002224) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_rooms", force: :cascade do |t|
    t.string "name"
    t.date "created_on"
    t.string "personality_types"
    t.boolean "is_public"
    t.text "announcements"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "admin_id"
    t.integer "messages_id", default: [], array: true
    t.integer "users_id", default: [], array: true
    t.boolean "direct_message", default: false
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "time_stamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chat_room_id"
    t.integer "user_id"
    t.text "body"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "chat_room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_room_id"], name: "index_participants_on_chat_room_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "personalities", force: :cascade do |t|
    t.string "name"
    t.string "interests", default: [], array: true
    t.string "compatible_personalities", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.integer "age"
    t.integer "zipcode"
    t.string "personality_type"
    t.string "interests", default: "{}"
    t.boolean "is_verified"
    t.boolean "is_online"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_messages_id", default: [], array: true
    t.integer "chat_rooms_id", default: [], array: true
    t.integer "friends_id", default: [], array: true
    t.string "picture"
    t.string "password"
    t.string "password_digest"
  end

  add_foreign_key "participants", "chat_rooms"
  add_foreign_key "participants", "users"
end
