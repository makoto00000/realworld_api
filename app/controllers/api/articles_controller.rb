class Api::ArticlesController < ApplicationController

  before_action :authenticate
  before_action :set_article, only: %i[show update destroy]

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
    render_article(@article)
  end
  
  def update
    unless owner?(@article)
      render_unauthorized and return
    end
    if @article.update(article_params)
      render_article(@article)
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    unless owner?(@article)
      render_unauthorized and return
    end
    @article.destroy
  end

  private
  def article_params
    params.require(:article).permit(:title, :description, :body, tagList: [])
  end

  def set_article
    @article = Article.find_by(slug: params[:slug])
  end

  def render_article(article)
    render json: {article: {slug: article.slug, title: article.title, description: article.description, body: article.body, tagList: article.tags.pluck(:name), createdAt: article.created_at, updatedAt: article.updated_at, favorited: true, favoritesCount: 0, author: article.user.attributes.slice("username", "bio", "image").merge({following: true})}}
  end
end
