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

ActiveRecord::Schema.define(:version => 20110524024132) do

  create_table "authors", :force => true do |t|
    t.string  "name",                    :null => false
    t.integer "author_address_id"
    t.integer "author_address_extra_id"
    t.string  "organization_id"
    t.string  "owned_essay_id"
  end

  create_table "comments", :force => true do |t|
    t.integer "post_id",                       :null => false
    t.text    "body",                          :null => false
    t.string  "type"
    t.integer "taggings_count", :default => 0
  end

  create_table "essays", :force => true do |t|
    t.string "name"
    t.string "writer_id"
    t.string "writer_type"
    t.string "category_id"
    t.string "author_id"
  end

  create_table "posts", :force => true do |t|
    t.integer "author_id"
    t.string  "title",                                         :null => false
    t.text    "body",                                          :null => false
    t.string  "type"
    t.integer "comments_count",                 :default => 0
    t.integer "taggings_count",                 :default => 0
    t.integer "taggings_with_delete_all_count", :default => 0
    t.integer "taggings_with_destroy_count",    :default => 0
    t.integer "tags_count",                     :default => 0
    t.integer "tags_with_destroy_count",        :default => 0
    t.integer "tags_with_nullify_count",        :default => 0
  end

  create_table "todos", :force => true do |t|
    t.string   "title"
    t.boolean  "done"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
