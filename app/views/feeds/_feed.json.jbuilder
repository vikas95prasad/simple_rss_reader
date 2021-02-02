json.extract! feed, :id, :title, :url, :user_id, :created_at, :updated_at
json.url feed_url(feed, format: :json)
