# frozen_string_literal: true

class CreateArticleTags < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    create_table :article_tags do |t|
      t.references :article, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
