# frozen_string_literal: true

class PostsController < ApplicationController
  include LimitOffsetConcern

  has_limit_offset_constraints only: [
    :index
  ], limit_default: 10, offset_default: 0

  def index
    @page = current_page
    @posts = Post.recents.limit(limit).offset(offset)
  end
end
