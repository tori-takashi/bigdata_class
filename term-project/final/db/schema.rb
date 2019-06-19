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

ActiveRecord::Schema.define(version: 2019_06_19_071625) do

  create_table "article_contents", force: :cascade do |t|
    t.string "contents"
    t.string "created_at"
    t.string "version_part"
  end

  create_table "article_details", force: :cascade do |t|
    t.string "title"
    t.string "summary"
    t.string "offerPrice"
    t.string "updated_at"
    t.string "article_contents_directoryID"
    t.string "version"
  end

  create_table "article_summaries", force: :cascade do |t|
    t.string "author_name"
    t.string "author_public_hash"
    t.string "created_at"
    t.string "author_manipulate_directoryID"
    t.string "article_details_directoryID"
    t.string "purchased_users_directoryID"
  end

  create_table "user_transaction_histories", force: :cascade do |t|
    t.string "amount"
    t.string "reason"
    t.string "details"
    t.string "created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
    t.string "user_public_hash"
    t.string "user_private_hash"
    t.string "password"
    t.string "user_transactions_directoryID"
  end

end
