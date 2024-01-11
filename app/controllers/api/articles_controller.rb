class Api::ArticlesController < ApplicationController

  before_action :authenticate, only: %i[create update destroy favorite unfavorite]
  before_action :set_article, only: %i[show update destroy favorite unfavorite]

  def index
    @articles = Article.order(created_at: :desc).includes(:user)
    @articles = @articles.offset(params[:offset]).limit(params[:limit]) if params[:offset].present? and params[:limit].present?
    render json: {articles: @articles, article_count: Article.all.count}, :include => :user
  end

  def create
    @article = @current_user.articles.build(article_params.except(:tagList))
    if @article.save
      @article.sync_tags(article_params[:tagList])
      render_article(@article)
    else
      render json: {errors: {body: @article.errors}}, status: :unprocessable_entity
    end
  end

  def show
    render_article(@article)
  end
  
  def update
    unless owner?(@article)
      render_unauthorized and return
    end
    if @article.update(article_params.except(:tagList))
      @article.sync_tags(article_params[:tagList])
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

  def favorite
    @article.favorite @current_user
    render_article(@article)
  end

  def unfavorite
    @article.unfavorite @current_user
    render_article(@article)
  end

  private
  def article_params
    params.require(:article).permit(:title, :description, :body, tagList: [])
  end

  def set_article
    @article = Article.find_by(slug: params[:slug])
  end

  def render_article(article)
    render json: {article: {slug: article.slug, title: article.title, description: article.description, body: article.body, tagList: article.tags.pluck(:name), createdAt: article.created_at, updatedAt: article.updated_at, favorited: article.users.include?(@current_user), favoritesCount: article.users.count, author: article.user.attributes.slice("username", "bio", "image").merge({following: true})}}
  end
end
