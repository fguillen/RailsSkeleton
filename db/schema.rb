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

ActiveRecord::Schema.define(version: 2021_11_25_173815) do

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_id", null: false
    t.string "record_type", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_authorizations", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "admin_user_id"
    t.index ["admin_user_id"], name: "index_admin_authorizations_on_admin_user_id"
  end

  create_table "admin_users", primary_key: "uuid", id: :string, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "password_salt"
    t.string "perishable_token"
    t.string "persistence_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perishable_token"], name: "index_admin_users_on_perishable_token", unique: true
    t.index ["persistence_token"], name: "index_admin_users_on_persistence_token", unique: true
    t.index ["uuid"], name: "index_admin_users_on_uuid", unique: true
  end

  create_table "data_migrations", primary_key: "version", id: :string, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
  end

  create_table "front_authorizations", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "front_user_id"
    t.index ["front_user_id"], name: "index_front_authorizations_on_front_user_id"
  end

  create_table "front_users", primary_key: "uuid", id: :string, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "password_salt"
    t.string "perishable_token"
    t.string "persistence_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["perishable_token"], name: "index_front_users_on_perishable_token", unique: true
    t.index ["persistence_token"], name: "index_front_users_on_persistence_token", unique: true
    t.index ["uuid"], name: "index_front_users_on_uuid", unique: true
  end

  create_table "log_book_events", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "historian_id", limit: 36
    t.string "historian_type"
    t.string "historizable_id", limit: 36
    t.string "historizable_type"
    t.text "differences", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_log_book_events_on_created_at"
    t.index ["historizable_id", "historizable_type", "created_at"], name: "index_log_book_events_on_historizable_and_created_at"
  end

  create_table "posts", primary_key: "uuid", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.string "front_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["front_user_id"], name: "fk_rails_810328b070"
    t.index ["uuid"], name: "index_posts_on_uuid", unique: true
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "taggings", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.string "taggable_id", limit: 36
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "posts", "front_users", primary_key: "uuid"
  add_foreign_key "taggings", "tags"
end
