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

ActiveRecord::Schema[8.0].define(version: 2025_11_18_153657) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string "title", limit: 120, null: false
    t.string "language_code", null: false
    t.string "level"
    t.text "description"
    t.boolean "is_published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_published"], name: "index_courses_on_is_published"
    t.index ["language_code"], name: "index_courses_on_language_code"
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.string "status", default: "active", null: false
    t.integer "progress_percent", default: 0, null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "status"], name: "index_enrollments_on_course_id_and_status"
    t.index ["course_id"], name: "index_enrollments_on_course_id"
    t.index ["user_id", "course_id"], name: "index_enrollments_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "title", null: false
    t.integer "order_index", null: false
    t.text "description"
    t.string "video_url"
    t.integer "expected_duration_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "order_index"], name: "index_lessons_on_course_id_and_order_index"
    t.index ["course_id"], name: "index_lessons_on_course_id"
  end

  create_table "session_analyses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "lesson_id", null: false
    t.integer "overall_score"
    t.integer "fluency_score"
    t.integer "grammar_score"
    t.integer "pronunciation_score"
    t.text "feedback_text"
    t.string "recorded_video_url"
    t.text "raw_transcript"
    t.datetime "session_started_at"
    t.datetime "session_ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_session_analyses_on_lesson_id"
    t.index ["user_id", "lesson_id"], name: "index_session_analyses_on_user_id_and_lesson_id"
    t.index ["user_id"], name: "index_session_analyses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.string "role", default: "student", null: false
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "enrollments", "courses"
  add_foreign_key "enrollments", "users"
  add_foreign_key "lessons", "courses"
  add_foreign_key "session_analyses", "lessons"
  add_foreign_key "session_analyses", "users"
end
