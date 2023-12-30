class CreateArticlesUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :articles_users do |t|
      t.references :article, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
