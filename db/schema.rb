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

ActiveRecord::Schema.define(version: 2021_10_21_111647) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "archives", force: :cascade do |t|
    t.string "url", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uuid", null: false
    t.index ["user_id"], name: "index_archives_on_user_id"
    t.index ["uuid"], name: "index_archives_on_uuid", unique: true
  end

  create_table "dns_records", force: :cascade do |t|
    t.bigint "zone_file_id", null: false
    t.text "content", null: false
    t.integer "priority"
    t.integer "record_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["zone_file_id"], name: "index_dns_records_on_zone_file_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "html_documents", force: :cascade do |t|
    t.text "source_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "screenshot_id", null: false
    t.index ["screenshot_id"], name: "index_html_documents_on_screenshot_id"
  end

  create_table "pay_charges", id: :serial, force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.string "processor", null: false
    t.string "processor_id", null: false
    t.integer "amount", null: false
    t.integer "amount_refunded"
    t.string "card_type"
    t.string "card_last4"
    t.string "card_exp_month"
    t.string "card_exp_year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pay_subscriptions", id: :serial, force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.string "name", null: false
    t.string "processor", null: false
    t.string "processor_id", null: false
    t.string "processor_plan", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "trial_ends_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price_in_cents"
    t.string "processor_id"
    t.integer "interval", default: 0, null: false
    t.boolean "public", default: false, null: false
    t.integer "website_limit"
    t.integer "webpage_limit"
    t.integer "job_schedule_frequency", default: 0, null: false
    t.string "uuid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uuid"], name: "index_plans_on_uuid", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "title", null: false
    t.integer "status", default: 0, null: false
    t.text "meta_description"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "redemption_codes", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.string "value", null: false
    t.datetime "trial_ends_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_redemption_codes_on_plan_id"
    t.index ["value"], name: "index_redemption_codes_on_value", unique: true
  end

  create_table "redemptions", force: :cascade do |t|
    t.bigint "redemption_code_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["redemption_code_id"], name: "index_redemptions_on_redemption_code_id"
    t.index ["user_id"], name: "index_redemptions_on_user_id"
  end

  create_table "screenshots", force: :cascade do |t|
    t.bigint "webpage_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["webpage_id"], name: "index_screenshots_on_webpage_id"
  end

  create_table "stats", force: :cascade do |t|
    t.jsonb "payload", default: {}
    t.jsonb "score", default: {}
    t.bigint "screenshot_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["screenshot_id"], name: "index_stats_on_screenshot_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "processor"
    t.string "processor_id"
    t.datetime "trial_ends_at"
    t.string "card_type"
    t.string "card_last4"
    t.string "card_exp_month"
    t.string "card_exp_year"
    t.text "extra_billing_info"
    t.boolean "accepted_terms", null: false
    t.boolean "admin"
    t.boolean "guest", default: false, null: false
    t.integer "archives_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webpages", force: :cascade do |t|
    t.bigint "website_id", null: false
    t.string "title", null: false
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["website_id"], name: "index_webpages_on_website_id"
  end

  create_table "websites", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "archive_id"
    t.index ["archive_id"], name: "index_websites_on_archive_id"
    t.index ["user_id"], name: "index_websites_on_user_id"
  end

  create_table "zone_files", force: :cascade do |t|
    t.bigint "website_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["website_id"], name: "index_zone_files_on_website_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "archives", "users"
  add_foreign_key "dns_records", "zone_files"
  add_foreign_key "html_documents", "screenshots"
  add_foreign_key "redemption_codes", "plans"
  add_foreign_key "redemptions", "redemption_codes"
  add_foreign_key "redemptions", "users"
  add_foreign_key "screenshots", "webpages"
  add_foreign_key "stats", "screenshots"
  add_foreign_key "webpages", "websites"
  add_foreign_key "websites", "archives"
  add_foreign_key "websites", "users"
  add_foreign_key "zone_files", "websites"
end
