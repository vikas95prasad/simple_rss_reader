# frozen_string_literal: true

class UrlGenerator
  def self.hash(url)
    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError
      uri = URI.parse(CGI.escape(url))
    end
    Digest::SHA256.hexdigest URI(uri).normalize.to_s
  end
end
