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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131016192716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "member_applications", force: true do |t|
    t.text     "user_uuid"
    t.date     "approved_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "why_you_want_to_join"
    t.string   "gender"
    t.text     "experience_level"
    t.integer  "confidence_technical_skills"
    t.integer  "basic_programming_knowledge"
    t.integer  "comfortable_learning"
    t.text     "current_projects"
    t.text     "time_commitment"
    t.text     "hurdles"
    t.text     "excited_about"
    t.text     "anything_else"
    t.string   "name"
  end

  create_table "mentor_applications", force: true do |t|
    t.text     "user_uuid"
    t.date     "approved_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "contact"
    t.string   "geography"
    t.string   "shirt_size"
    t.string   "hear_about"
    t.text     "motivation"
    t.string   "time_commitment"
    t.string   "mentor_one_on_one"
    t.string   "mentor_group"
    t.string   "mentor_online"
    t.string   "volunteer_events"
    t.string   "volunteer_teams"
    t.string   "volunteer_solo"
    t.string   "volunteer_technical"
    t.string   "volunteer_online"
  end

end
