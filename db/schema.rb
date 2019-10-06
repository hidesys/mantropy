# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_06_071607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorideas", id: :serial, force: :cascade do |t|
    t.integer "identify"
    t.integer "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "idea"
  end

  create_table "authors", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_books", id: :serial, force: :cascade do |t|
    t.string "role"
    t.integer "author_id"
    t.integer "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_series", id: :serial, force: :cascade do |t|
    t.string "role"
    t.integer "author_id"
    t.integer "serie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookaffairs", id: :serial, force: :cascade do |t|
    t.integer "event"
    t.integer "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookreals", id: :serial, force: :cascade do |t|
    t.integer "book_id"
    t.text "memo"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.string "isbn"
    t.string "name"
    t.string "publisher"
    t.date "publicationdate"
    t.string "detailurl"
    t.string "smallimgurl"
    t.string "mediumimgurl"
    t.string "largeimgurl"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "asin"
    t.string "label"
    t.boolean "iscomic"
    t.string "kind"
    t.index ["isbn"], name: "index_books_on_isbn"
    t.index ["iscomic"], name: "index_books_on_iscomic"
    t.index ["name"], name: "index_books_on_name"
  end

  create_table "books_browsenodeids", id: false, force: :cascade do |t|
    t.integer "book_id"
    t.integer "browsenodeid_id"
  end

  create_table "books_series", id: false, force: :cascade do |t|
    t.integer "book_id"
    t.integer "serie_id"
  end

  create_table "browsenodeids", id: :serial, force: :cascade do |t|
    t.bigint "node"
    t.string "name"
    t.bigint "ancestor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "magazines", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "publisher"
    t.string "url"
    t.integer "appear"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "book_id"
  end

  create_table "magazines_series", id: :serial, force: :cascade do |t|
    t.string "placed"
    t.integer "magazine_id"
    t.integer "serie_id"
  end

  create_table "postfavs", id: :serial, force: :cascade do |t|
    t.integer "score"
    t.integer "post_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "order"
    t.text "content"
    t.integer "topic_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rankings", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_registerable"
    t.integer "scope_min"
    t.integer "scope_max"
    t.string "kind"
  end

  create_table "ranks", id: :serial, force: :cascade do |t|
    t.integer "rank"
    t.integer "score"
    t.integer "ranking_id"
    t.integer "user_id"
    t.integer "serie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "url"
    t.integer "topic_id"
  end

  create_table "series_tags", id: false, force: :cascade do |t|
    t.integer "serie_id"
    t.integer "tag_id"
  end

  create_table "site_configs", force: :cascade do |t|
    t.string "path", null: false
    t.string "name", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["path"], name: "index_site_configs_on_path"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "appear"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfers", id: :serial, force: :cascade do |t|
    t.integer "bookreal_id"
    t.integer "from"
    t.integer "to"
    t.date "when"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userauths", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "password_salt"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_userauths_on_email", unique: true
    t.index ["reset_password_token"], name: "index_userauths_on_reset_password_token", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "realname"
    t.string "pcmail"
    t.string "mbmail"
    t.string "twitter"
    t.string "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "publicabout"
    t.string "privateabout"
    t.string "joined"
    t.string "entered"
  end

  create_table "wikis", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.string "content"
    t.integer "is_private"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
