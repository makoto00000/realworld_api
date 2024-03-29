# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
