# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :feed

  validates_presence_of :url
  validates :url, url: true
  validates_presence_of :url_hash
  validates_uniqueness_of :url_hash

  before_save :create_url_hash

  scope :recents, -> { order('published_at desc') }
  scope :by_url, ->(url) { where(url_hash: Post.create_url_hash(url)) }

  def self.create_url_hash(url)
    UrlGenerator.hash(url)
  end
end
