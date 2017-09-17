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

ActiveRecord::Schema.define(version: 20170917111022) do

  create_table "authorideas", force: :cascade do |t|
    t.integer "identify"
    t.integer "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "idea"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_books", force: :cascade do |t|
    t.string "role", limit: 255
    t.integer "author_id"
    t.integer "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_series", force: :cascade do |t|
    t.string "role", limit: 255
    t.integer "author_id"
    t.integer "serie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookaffairs", force: :cascade do |t|
    t.integer "event"
    t.integer "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookreals", force: :cascade do |t|
    t.integer "book_id"
    t.text "memo"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", force: :cascade do |t|
    t.string "isbn", limit: 255
    t.string "name", limit: 255
    t.string "publisher", limit: 255
    t.date "publicationdate"
    t.string "detailurl", limit: 255
    t.string "smallimgurl", limit: 255
    t.string "mediumimgurl", limit: 255
    t.string "largeimgurl", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "asin", limit: 255
    t.string "label", limit: 255
    t.boolean "iscomic"
    t.string "kind", limit: 255
  end

  create_table "books_browsenodeids", id: false, force: :cascade do |t|
    t.integer "book_id"
    t.integer "browsenodeid_id"
  end

  create_table "books_series", id: false, force: :cascade do |t|
    t.integer "book_id"
    t.integer "serie_id"
  end

  create_table "browsenodeids", force: :cascade do |t|
    t.integer "node", limit: 8
    t.string "name", limit: 255
    t.integer "ancestor", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "magazines", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "publisher", limit: 255
    t.string "url", limit: 255
    t.integer "appear"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "book_id"
  end

  create_table "magazines_series", force: :cascade do |t|
    t.string "placed", limit: 255
    t.integer "magazine_id"
    t.integer "serie_id"
  end

  create_table "postfavs", force: :cascade do |t|
    t.integer "score"
    t.integer "post_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.integer "order"
    t.text "content"
    t.integer "topic_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "rankings" because of following StandardError
#   Unknown type 'bool' for column 'is_registerable'

  create_table "ranks", force: :cascade do |t|
    t.integer "rank"
    t.integer "score"
    t.integer "ranking_id"
    t.integer "user_id"
    t.integer "serie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "url", limit: 255
    t.integer "topic_id"
  end

  create_table "series_tags", id: false, force: :cascade do |t|
    t.integer "serie_id"
    t.integer "tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: :cascade do |t|
    t.string "title", limit: 255
    t.integer "appear"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfers", force: :cascade do |t|
    t.integer "bookreal_id"
    t.integer "from"
    t.integer "to"
    t.date "when"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userauths", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "password_salt", limit: 255
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_userauths_on_email", unique: true
    t.index ["reset_password_token"], name: "index_userauths_on_reset_password_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "realname", limit: 255
    t.string "pcmail", limit: 255
    t.string "mbmail", limit: 255
    t.string "twitter", limit: 255
    t.string "url", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "publicabout", limit: 255
    t.string "privateabout", limit: 255
    t.string "joined", limit: 255
    t.string "entered", limit: 255
  end

  create_table "wikis", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "title", limit: 255
    t.string "content", limit: 255
    t.integer "is_private"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
