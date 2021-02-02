# frozen_string_literal: true

require 'active_support/concern'

module LimitOffsetConcern
  extend ActiveSupport::Concern
  LIMIT = 10

  protected

  def current_page
    @page = params.fetch(:page, 0).to_i
  end

  def limit
    @limit
  end

  def offset
    @offset
  end

  def set_limit_and_offset_default
    @limit = fetch_limit
    @offset = fetch_offset
  rescue StandardError
    render json: { message: 'Invalid params: Limit or Offset.' },
           status: :unprocessable_entity
  end

  def fetch_offset
    (current_page * limit ||
      params[:offset] ||
      self.class.limit_offset_options[:offset_default]).to_i
  end

  def fetch_limit
    (params[:limit] || self.class.limit_offset_options[:limit_default]).to_i
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
