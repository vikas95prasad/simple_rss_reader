# frozen_string_literal: true

module FeedParse
  module Parsers
    class Rss
      class << self
        def can_parse?(xml)
          (/<rss|<rdf/ =~ xml) && !(/feedburner/ =~ xml)
        end

        def parse(xml)
          parsed_data = []
          xml.search('item').each do |entry|
            parsed_data << {
              title: entry.at('title').text.strip,
              url: entry.at('link').text.strip,
              published_at: entry.at('pubDate').text.strip
            }
          end
          parsed_data
        end
      end
    end
  end
end
