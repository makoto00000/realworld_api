class Api::ArticlesController < ApplicationController

  before_action :authenticate

  def create
    @article = @current_user.articles.build(article_params.except(:tagList))
    if @article.save
      @article.sync_tags(article_params[:tagList])
      render json: {article: {slug: @article.slug, title: @article.title, description: @article.description, body: @article.body, tagList: @article.tags.pluck(:name), createdAt: @article.created_at, updatedAt: @article.updated_at, favorited: true, favoritesCount: 0, author: {username: @current_user.username, bio: @current_user.bio, image: @current_user.image, following: true}}}
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :description, :body, tagList: [])
  end
end
