# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :url
      t.string :url_hash
      t.datetime :published_at, index: true
      t.belongs_to :feed, index: true

      t.timestamps null: false
    end

    add_index :posts, :url_hash, unique: true, name: 'unique_index_posts_on_url_hash'
  end
end
