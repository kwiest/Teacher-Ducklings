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

ActiveRecord::Schema.define(:version => 20120215230600) do

  create_table "categories", :force => true do |t|
    t.string "name"
  end

  create_table "categories_links", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "link_id"
  end

  create_table "categories_posts", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "post_id"
  end

  create_table "comments", :force => true do |t|
    t.integer   "post_id"
    t.integer   "user_id"
    t.string    "name"
    t.string    "email"
    t.text      "body"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "links", :force => true do |t|
    t.string    "name"
    t.string    "url"
    t.text      "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "document_file_name"
    t.string    "document_content_type"
    t.integer   "document_file_size"
  end

  create_table "meetings", :force => true do |t|
    t.integer   "video_id"
    t.date      "date"
    t.string    "time"
    t.boolean   "confirmed"
    t.integer   "creator_id"
    t.integer   "user_to_meet_with_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "tok_session_id"
  end

  create_table "posts", :force => true do |t|
    t.integer   "user_id"
    t.string    "title"
    t.text      "body"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer   "video_id"
    t.integer   "user_id"
    t.text      "description"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "pdf_file_name"
    t.string    "pdf_content_type"
    t.integer   "pdf_file_size"
  end

  create_table "users", :force => true do |t|
    t.string    "email",              :null => false
    t.string    "crypted_password",   :null => false
    t.string    "password_salt",      :null => false
    t.string    "persistence_token",  :null => false
    t.string    "perishable_token",   :null => false
    t.string    "first_name"
    t.string    "last_name"
    t.string    "phone_number"
    t.boolean   "admin"
    t.timestamp "last_login_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
  end

  create_table "videos", :force => true do |t|
    t.integer   "user_id"
    t.string    "title"
    t.text      "description"
    t.string    "video_file_name"
    t.string    "state"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "zencoder_job_id"
    t.text      "zencoder_error_message"
  end

end
