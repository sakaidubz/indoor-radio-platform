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

ActiveRecord::Schema[7.1].define(version: 202509140004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.string "genre"
    t.string "theme_color"
    t.text "bio"
    t.string "photo_url"
    t.string "logo_url"
    t.string "x_id"
    t.string "instagram_id"
    t.string "soundcloud_id"
    t.text "other_links"
    t.string "status", default: "draft"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "episodes", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.string "title", null: false
    t.datetime "scheduled_date"
    t.string "soundcloud_url"
    t.string "artwork_url"
    t.string "status", default: "planning"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_episodes_on_artist_id"
  end

  create_table "social_posts", force: :cascade do |t|
    t.bigint "episode_id", null: false
    t.string "platform", null: false
    t.text "content", null: false
    t.datetime "scheduled_at"
    t.datetime "posted_at"
    t.string "post_id"
    t.string "status", default: "scheduled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["episode_id"], name: "index_social_posts_on_episode_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "editor", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "episodes", "artists"
  add_foreign_key "social_posts", "episodes"
end
