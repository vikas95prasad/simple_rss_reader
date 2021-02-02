# frozen_string_literal: true

module FeedManager
  class PostsCreatorValidator < ApplicationValidator
    attr_reader :feed_id, :url

    validates :feed_id, :url, presence: true

    def initialize(opts = {})
      @feed_id = opts[:feed_id]
      @url = opts[:url]
    end
  end
end
