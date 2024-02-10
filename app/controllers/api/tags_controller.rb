# frozen_string_literal: true

module Api
  class TagsController < ApplicationController # rubocop:disable Style/Documentation
    def index
      @tags = Tag.all
      if @tags
        render json: { tagList: @tags.pluck(:name) }
      else
        render json: { errors: { body: @tags.errors } }
      end
    end
  end
end
