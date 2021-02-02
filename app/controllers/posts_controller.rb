# frozen_string_literal: true

class PostsController < ApplicationController
  include LimitOffsetConcern

  has_limit_offset_constraints only: [
    :index
  ], limit_default: 15, offset_default: 0

  def index
    @posts = Post.recents.limit(limit).offset(offset)
  end
end
