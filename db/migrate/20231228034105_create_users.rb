class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :token
      t.text :bio, default: ""
      t.string :image

      t.timestamps
    end
    add_index :users, [:username, :email], unique: true
  end
end
