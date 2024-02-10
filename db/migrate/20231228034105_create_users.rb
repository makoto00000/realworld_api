# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :token
      t.string :bio, default: ''
      t.string :image

      t.timestamps
    end
    add_index :users, %i[username email], unique: true
  end
end
