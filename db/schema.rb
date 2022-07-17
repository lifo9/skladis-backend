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

ActiveRecord::Schema[7.0].define(version: 2022_07_17_145122) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street_name"
    t.string "street_number"
    t.string "city"
    t.string "zip"
    t.string "country"
    t.point "coordinates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "barcodes", force: :cascade do |t|
    t.string "barcode_type"
    t.string "barcode_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_items", force: :cascade do |t|
    t.bigint "invoice_id", null: false
    t.bigint "product_id", null: false
    t.bigint "supplier_id", null: false
    t.decimal "unit_price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_items_on_product_id"
    t.index ["supplier_id"], name: "index_invoice_items_on_supplier_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_code"
    t.datetime "invoice_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "stocked_in", default: false, null: false
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_locations_on_room_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_code"
    t.integer "pieces_ideal"
    t.integer "pieces_critical"
    t.bigint "barcode_id"
    t.index ["barcode_id"], name: "index_products_on_barcode_id"
  end

  create_table "products_suppliers", id: false, force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "supplier_id"
    t.index ["product_id"], name: "index_products_suppliers_on_product_id"
    t.index ["supplier_id"], name: "index_products_suppliers_on_supplier_id"
  end

  create_table "registration_invitations", force: :cascade do |t|
    t.bigint "user_id"
    t.string "registration_key", null: false
    t.boolean "used", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "activation_key", default: "f", null: false
    t.index ["user_id"], name: "index_registration_invitations_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.bigint "warehouse_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["warehouse_id"], name: "index_rooms_on_warehouse_id"
  end

  create_table "stock_transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "stock_id"
    t.string "action", null: false
    t.integer "pieces", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_transactions_on_stock_id"
    t.index ["user_id"], name: "index_stock_transactions_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "room_id", null: false
    t.datetime "expiration"
    t.integer "pieces", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "location_id"
    t.index ["location_id"], name: "index_stocks_on_location_id"
    t.index ["product_id", "room_id", "expiration"], name: "index_stocks_on_product_id_and_room_id_and_expiration", unique: true
    t.index ["product_id"], name: "index_stocks_on_product_id"
    t.index ["room_id"], name: "index_stocks_on_room_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "ico"
    t.string "dic"
    t.string "url"
    t.bigint "address_id"
    t.bigint "contact_id"
    t.decimal "free_delivery_from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ic_dph"
    t.index ["address_id"], name: "index_suppliers_on_address_id"
    t.index ["contact_id"], name: "index_suppliers_on_contact_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false, null: false
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.string "item_subtype"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "warehouses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "address_id"
    t.index ["address_id"], name: "index_warehouses_on_address_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "products"
  add_foreign_key "invoice_items", "suppliers"
  add_foreign_key "invoices", "users"
  add_foreign_key "locations", "rooms"
  add_foreign_key "products", "barcodes"
  add_foreign_key "registration_invitations", "users"
  add_foreign_key "rooms", "warehouses"
  add_foreign_key "stock_transactions", "stocks"
  add_foreign_key "stock_transactions", "users"
  add_foreign_key "stocks", "locations"
  add_foreign_key "stocks", "products"
  add_foreign_key "stocks", "rooms"
  add_foreign_key "suppliers", "addresses"
  add_foreign_key "suppliers", "contacts"
  add_foreign_key "warehouses", "addresses"
end
