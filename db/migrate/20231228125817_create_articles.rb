# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    create_table :articles do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :description
      t.text :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :articles, :slug, unique: true
  end
end
