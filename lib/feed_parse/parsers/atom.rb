# frozen_string_literal: true

module FeedParse
  module Parsers
    class Atom
      class << self
        def can_parse?(xml)
          %r{<feed[^>]+xmlns\s?=\s?["'](http://www\.w3\.org/2005/Atom|http://purl\.org/atom/ns\#)["'][^>]*>} =~ xml
        end

        def parse(xml)
          parsed_data = []
          xml.search('entry').each do |entry|
            parsed_data << {
              title: entry.at('title').text.strip,
              url: entry.at('link')['href'].strip,
              published_at: entry.at('published').text.strip
            }
          end
          parsed_data
        end
      end
    end
  end
end
