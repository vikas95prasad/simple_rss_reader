# frozen_string_literal: true

class CreateFeeds < ActiveRecord::Migration[6.1]
  def change
    create_table :feeds do |t|
      t.string :url
      t.string :title

      t.timestamps null: false
    end

    add_index :feeds, :url, unique: true, name: 'unique_index_feeds_on_url'
  end
end
