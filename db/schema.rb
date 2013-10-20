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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131020204522) do

  create_table "authorideas", :force => true do |t|
    t.integer  "identify"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "idea"
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_books", :force => true do |t|
    t.string   "role"
    t.integer  "author_id"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors_series", :force => true do |t|
    t.string   "role"
    t.integer  "author_id"
    t.integer  "serie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookaffairs", :force => true do |t|
    t.integer  "event"
    t.integer  "book_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookreals", :force => true do |t|
    t.integer  "book_id"
    t.text     "memo"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", :force => true do |t|
    t.string   "isbn"
    t.string   "name"
    t.string   "publisher"
    t.date     "publicationdate"
    t.string   "detailurl"
    t.string   "smallimgurl"
    t.string   "mediumimgurl"
    t.string   "largeimgurl"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "asin"
    t.string   "label"
    t.boolean  "iscomic"
    t.string   "kind"
  end

  create_table "books_browsenodeids", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "browsenodeid_id"
  end

  create_table "books_series", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "serie_id"
  end

  create_table "browsenodeids", :force => true do |t|
    t.integer  "node"
    t.string   "name"
    t.integer  "ancestor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "magazines", :force => true do |t|
    t.string   "name"
    t.string   "publisher"
    t.string   "url"
    t.integer  "appear"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "book_id"
  end

  create_table "magazines_series", :id => false, :force => true do |t|
    t.integer "magazine_id"
    t.integer "serie_id"
  end

  create_table "postfavs", :force => true do |t|
    t.integer  "score"
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "order"
    t.text     "content"
    t.integer  "topic_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

# Could not dump table "rankings" because of following StandardError
#   Unknown type 'bool' for column 'is_registerable'

  create_table "ranks", :force => true do |t|
    t.integer  "rank"
    t.integer  "score"
    t.integer  "ranking_id"
    t.integer  "user_id"
    t.integer  "serie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", :force => true do |t|
    t.string   "name"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "topic_id"
  end

  create_table "series_tags", :id => false, :force => true do |t|
    t.integer "serie_id"
    t.integer "tag_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.integer  "appear"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfers", :force => true do |t|
    t.integer  "bookreal_id"
    t.integer  "from"
    t.integer  "to"
    t.date     "when"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userauths", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "userauths", ["email"], :name => "index_userauths_on_email", :unique => true
  add_index "userauths", ["reset_password_token"], :name => "index_userauths_on_reset_password_token", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "realname"
    t.string   "pcmail"
    t.string   "mbmail"
    t.string   "twitter"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publicabout"
    t.string   "privateabout"
    t.string   "joined"
    t.string   "entered"
  end

  create_table "wikis", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "content"
    t.integer  "is_private"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
