# frozen_string_literal: true

require 'uri'

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      URI.parse(value)
      response = true
    rescue URI::InvalidURIError
      response = false
    end
    record.errors[attribute] << (options[:message] || 'is not valid URL') unless response == true
  end
end
