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

ActiveRecord::Schema.define(:version => 20130206030750) do

  create_table "boards", :force => true do |t|
    t.string   "status"
    t.text     "detail_xml"
    t.integer  "winner_id"
    t.integer  "money_awarded"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", :force => true do |t|
    t.string   "description"
    t.string   "url"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.integer  "user_id"
    t.integer  "board_id"
    t.integer  "card_id"
    t.integer  "question_count"
    t.integer  "guess_count"
    t.integer  "opponent_game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "turns", :force => true do |t|
    t.integer  "game_id"
    t.string   "question"
    t.boolean  "answer"
    t.boolean  "is_guess"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "facebook_id"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "money"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
