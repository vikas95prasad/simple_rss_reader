# frozen_string_literal: true

module FeedManager
  class PostsCreatorService < ApplicationService
    def initialize(opts = {})
      @opts = opts
      @url = opts[:url]
      @feed_id = opts[:feed_id]
    end

    def call
      validator = FeedManager::PostsCreatorValidator.new(@opts)
      if validator.valid?
        pull_posts_from_feed_url

        { status: 'Success' }
      else
        { status: 'Failed', errors: validator.errors.full_messages.join(', ') }
      end
    end

    private

    def pull_posts_from_feed_url
      entries = FeedParse::Parser.parse(@url)

      entries.each_slice(5) do |batch|
        batch.map do |post|
          build_params(post)
        end
        Post.insert_all(batch)
      end
    end

    def build_params(post)
      post.merge!(
        feed_id: @feed_id,
        url_hash: UrlGenerator.hash(post[:url]),
        created_at: Time.current,
        updated_at: Time.current
      )
    end
  end
end
