class Api::TagsController < ApplicationController

  def index
    @tags = Tag.all
    if @tags
      render json: {tagList: @tags.pluck(:name)}
    else
      render json: {errors: {body: @tags.errors}}
    end
  end
  
end
