ActiveRecord::Schema[7.1].define(version: 2023_12_28_034105) do
  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "token"
    t.text "bio"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username", "email"], name: "index_users_on_username_and_email", unique: true
  end

end
