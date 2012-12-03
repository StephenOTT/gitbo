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

ActiveRecord::Schema.define(:version => 20121130192453) do

  create_table "bounties", :force => true do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "collected_by_user_id", :default => 0
    t.integer  "price",                :default => 0
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.datetime "git_update_at"
    t.integer  "git_number"
    t.string   "owner_name"
    t.string   "owner_image"
    t.integer  "issue_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "issues", :force => true do |t|
    t.string   "title"
    t.integer  "git_number"
    t.text     "body",              :limit => 255
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.integer  "repo_id"
    t.integer  "comment_count"
    t.integer  "upvote"
    t.integer  "downvote"
    t.datetime "git_updated_at"
    t.string   "state"
    t.string   "owner_name"
    t.string   "owner_image"
    t.integer  "owner_endorsement",                :default => 0
    t.integer  "vote_count",                       :default => 0
    t.float    "avg_difficulty",                   :default => 0.0
    t.string   "repo_name"
    t.string   "repo_owner"
    t.integer  "bounty_total",                     :default => 0
  end

  create_table "repos", :force => true do |t|
    t.string   "name"
    t.string   "owner_name"
    t.text     "description",    :limit => 255
    t.integer  "watchers"
    t.integer  "open_issues"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "slug"
    t.datetime "git_updated_at"
  end

  add_index "repos", ["slug"], :name => "index_repos_on_slug"

  create_table "user_votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "issue_id"
    t.integer  "vote",              :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "difficulty_rating", :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "nickname"
    t.string   "email"
    t.string   "image"
    t.string   "token"
  end

end
