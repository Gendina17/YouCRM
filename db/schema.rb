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

ActiveRecord::Schema.define(version: 2021_12_11_160754) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.integer "company_id"
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "client_companies", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "phone"
    t.string "email"
    t.string "address"
    t.string "responsible"
    t.integer "points", default: 0
    t.integer "manager_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.string "address"
    t.text "description"
    t.integer "points", default: 0
    t.string "password"
    t.string "patronymic"
    t.integer "manager_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "password"
    t.boolean "is_send"
    t.boolean "is_show_avatar", default: false
    t.string "type_client"
    t.text "client_fields", default: ""
    t.string "type_product"
    t.boolean "show_statuses", default: true
    t.boolean "show_categories", default: true
    t.integer "default_email_id"
  end

  create_table "email_templates", force: :cascade do |t|
    t.text "body"
    t.string "subject"
    t.integer "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
  end

  create_table "emails", force: :cascade do |t|
    t.string "from"
    t.string "to"
    t.string "subject"
    t.string "body"
    t.boolean "incoming"
    t.integer "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date"
    t.integer "manager_id"
    t.string "client_type"
    t.bigint "client_id"
    t.index ["client_type", "client_id"], name: "index_emails_on_client"
  end

  create_table "events", force: :cascade do |t|
    t.text "body"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.integer "manager_id"
    t.string "client_type"
    t.bigint "client_id"
    t.index ["client_type", "client_id"], name: "index_events_on_client"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.integer "manager_id"
    t.integer "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ticket_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "date"
    t.string "type_product"
    t.integer "number"
    t.text "description"
    t.integer "price"
    t.boolean "is_important"
    t.integer "discount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.text "the_role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.boolean "is_admin", default: false
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.datetime "date"
    t.string "type_service"
    t.string "duration"
    t.integer "price"
    t.boolean "is_important"
    t.integer "discount"
    t.text "description"
    t.string "executor"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.integer "company_id"
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "subject"
    t.string "body"
    t.integer "creator_id"
    t.integer "user_id"
    t.date "until_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tag"
    t.boolean "active"
    t.boolean "is_new", default: true
  end

  create_table "ticket_logs", force: :cascade do |t|
    t.integer "ticket_id"
    t.string "message"
    t.string "loggable_type"
    t.integer "version_id"
    t.integer "manager_id"
    t.string "value"
    t.string "previos_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "attribute_name"
    t.integer "item_id"
  end

  create_table "ticket_versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.json "object"
    t.json "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_ticket_versions_on_item_type_and_item_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "status_id"
    t.integer "category_id"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_closed", default: false
    t.integer "company_id"
    t.string "client_type"
    t.bigint "client_id"
    t.string "product_type"
    t.bigint "product_id"
    t.integer "manager_id"
    t.string "subject"
    t.index ["client_type", "client_id"], name: "index_tickets_on_client"
    t.index ["product_type", "product_id"], name: "index_tickets_on_product"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "surname"
    t.integer "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.string "state"
    t.string "avatar"
    t.string "mood"
    t.string "info"
    t.json "contacts"
    t.integer "role_id"
    t.boolean "is_fired"
  end

  create_table "users_walls", id: false, force: :cascade do |t|
    t.bigint "wall_id"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_users_walls_on_user_id"
    t.index ["wall_id"], name: "index_users_walls_on_wall_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "walls", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "company_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tag"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
