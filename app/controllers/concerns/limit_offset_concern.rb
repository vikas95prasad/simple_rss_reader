# frozen_string_literal: true

require 'active_support/concern'

module LimitOffsetConcern
  extend ActiveSupport::Concern

  protected

  def set_limit_and_offset_default
    @limit = (params[:limit] || self.class.limit_offset_options[:limit_default]).to_i
    @offset = (params[:offset].presence.to_i || self.class.limit_offset_options[:offset_default]).to_i
  rescue StandardError
    render json: { message: 'Invalid params: Limit or Offset.' },
           status: :unprocessable_entity
  end

  def limit
    @limit
  end

  def offset
    @offset
  end

  class_methods do
    def has_limit_offset_constraints(options = {})
      class_attribute :limit_offset_options
      self.limit_offset_options = default_options.merge(options)
      before_action(:set_limit_and_offset_default, options)
    end

    def default_options
      {
        limit_default: 10,
        offset_default: 0
      }
    end
  end
end
