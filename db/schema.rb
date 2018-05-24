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

ActiveRecord::Schema.define(version: 20160822075905) do

  create_table "cities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "station_id"
    t.string   "customer_name"
    t.integer  "relationship"
    t.integer  "city"
    t.integer  "province"
    t.string   "address"
    t.string   "email"
    t.string   "pnumber"
    t.string   "avatar"
    t.string   "noid"
    t.integer  "gender"
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.date     "time_end"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["station_id"], name: "index_customers_on_station_id", using: :btree
  end

  create_table "genders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "fname"
    t.string   "lname"
    t.date     "dob"
    t.integer  "gender"
    t.string   "address"
    t.string   "email"
    t.string   "pnumber"
    t.string   "noid"
    t.date     "issue_date"
    t.string   "issue_place"
    t.string   "avatar"
    t.string   "signature"
    t.string   "brandname"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "station_id"
    t.text     "project_name",      limit: 65535
    t.text     "contractor",        limit: 65535
    t.text     "basic_info",        limit: 65535
    t.text     "address",           limit: 65535
    t.date     "day_start"
    t.date     "day_end"
    t.string   "logo"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.index ["station_id"], name: "index_projects_on_station_id", using: :btree
  end

  create_table "provinces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_provinces_on_city_id", using: :btree
  end

  create_table "sale_profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "fname"
    t.string   "lname"
    t.date     "dob"
    t.integer  "gender"
    t.integer  "city"
    t.integer  "province"
    t.string   "address"
    t.string   "email"
    t.string   "pnumber"
    t.string   "noid"
    t.date     "issue_date"
    t.string   "issue_place"
    t.string   "avatar"
    t.integer  "identify"
    t.string   "noid2"
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["user_id"], name: "index_sale_profiles_on_user_id", using: :btree
  end

  create_table "stations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "sname"
    t.integer  "city"
    t.integer  "province"
    t.string   "address"
    t.string   "pnumber"
    t.string   "hpage"
    t.string   "logo"
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.string   "Noid"
    t.date     "date_issue"
    t.string   "place_issue"
    t.string   "mst"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.index ["user_id"], name: "index_stations_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "pnumber"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "provider",          limit: 50,  default: "", null: false
    t.string   "uid",               limit: 500, default: "", null: false
    t.index ["name"], name: "index_users_on_name", unique: true, using: :btree
  end

  add_foreign_key "customers", "stations"
  add_foreign_key "profiles", "users"
  add_foreign_key "projects", "stations"
  add_foreign_key "provinces", "cities"
  add_foreign_key "sale_profiles", "users"
  add_foreign_key "stations", "users"
end
