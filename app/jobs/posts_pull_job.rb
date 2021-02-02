# frozen_string_literal: true

class PostsPullJob < ApplicationJob
  queue_as :default

  def perform(feed_id:)
    feed = Feed.find_by(id: feed_id)
    return if feed.nil?

    FeedManager::PostsCreatorService.new({ feed_id: feed.id, url: feed.url }).call
  end
end
