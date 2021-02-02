# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :feed

  validates_presence_of :url
  validates :url, url: true
  validates_presence_of :url_hash
  validates_uniqueness_of :url_hash

  before_save :generate_url_hash

  scope :recents, -> { order('published_at desc') }
  scope :by_url, ->(url) { where(url_hash: Post.get_url_hash(url)) }

  def self.get_url_hash(url)
    UrlGenerator.hash(url)
  end

  private

  def generate_url_hash
    # Hash the URL, but don't hash null values
    self[:url_hash] = (self.class.get_url_hash(self[:url]) if self[:url].present?)
  end
end
