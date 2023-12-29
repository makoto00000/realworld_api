class Api::ArticlesController < ApplicationController

  before_action :authenticate

  def create
    @article = @current_user.articles.build(article_params.except(:tagList))
    if @article.save
      @article.sync_tags(article_params[:tagList])
      render_article(@article)
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def show
    @article = Article.find_by(slug: params[:slug])
    render_article(@article)
  end
  
  def update
    @article = Article.find_by(slug: params[:slug])
    if @article.update(article_params)
      render_article(@article)
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :description, :body, tagList: [])
  end

  def render_article(article)
    render json: {article: {slug: article.slug, title: article.title, description: article.description, body: article.body, tagList: article.tags.pluck(:name), createdAt: article.created_at, updatedAt: article.updated_at, favorited: true, favoritesCount: 0, author: article.user.attributes.slice("username", "bio", "image").merge({following: true})}}
  end
end
