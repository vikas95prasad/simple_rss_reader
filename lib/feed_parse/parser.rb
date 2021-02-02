# frozen_string_literal: true

require 'net/http'
require 'open-uri'

# FLOW :
#        Generate XML
#            ⬇
#     Select The Parser
#            ⬇
#          Parse

module FeedParse
  class Parser
    class << self
      def parse(url)
        xml = Parser.xml_generator(url)
        return false if xml.nil?

        parser = Parser.select_parser(url)
        raise StandardError, 'Not a valid XML.' if parser.nil?

        parser.parse(xml)
      end

      def select_parser(url)
        meta_data = xml_metadata(url)
        Parser.parsers.detect { |klass| klass.can_parse?(meta_data) }
      end

      def parsers
        [
          Parsers::Atom,
          Parsers::Rss
        ]
      end

      def document_title(url)
        xml = Parser.xml_generator(url)
        return false if xml.nil?

        title = xml.search('title').map(&:text).first ||
                xml.xpath('//xmlns:title')[0].text ||
                xml.css('title')[0].text ||
                xml.xpath('//xmlns:title') ||
                xml.css('xmlns|title') ||
                xml.css('title') ||
                'Title Missing'
        title.strip
      end

      def xml_generator(url)
        Nokogiri::XML(open(url))
      rescue StandardError
        nil
      end

      def xml_metadata(url)
        Net::HTTP.get(URI.parse(url)).slice(0, 2000) || ''
      end
    end
  end
end
