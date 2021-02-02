# frozen_string_literal: true

class Feed < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates_presence_of :url
  validates :url, url: true
  validates_uniqueness_of :url
  validates_presence_of :title
  validate :validate_xml_format

  before_validation :set_title
  before_save :sanitize_title
  after_commit :pull_feed_posts

  private

  def set_title
    self.title = title.presence || FeedParse::Parser.document_title(url)
  end

  def sanitize_title
    self.title = title.gsub(/\n/, '').truncate(200, separator: ' ')
  end

  def validate_xml_format
    parser = FeedParse::Parser.select_parser(url)

    errors.add(:base, 'Invalid or Not Supported XML.') if parser.blank?
  end

  def pull_feed_posts
    PostsPullJob.perform_later(feed_id: id)
  end
end
