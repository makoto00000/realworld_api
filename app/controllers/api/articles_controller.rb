# frozen_string_literal: true

module Api
  class ArticlesController < ApplicationController # rubocop:disable Style/Documentation
    before_action :authenticate, only: %i[create update destroy favorite unfavorite]
    before_action :set_article, only: %i[show update destroy favorite unfavorite]

    def index # rubocop:disable Metrics/AbcSize
      @articles = Article.order(created_at: :desc).includes(:user)
      if params[:offset].present? && params[:limit].present?
        @articles = @articles.offset(params[:offset]).limit(params[:limit])
      end
      render json: { articles: @articles, article_count: Article.all.count }, include: :user
    end

    def create
      @article = @current_user.articles.build(article_params.except(:tagList))
      if @article.save
        @article.sync_tags(article_params[:tagList])
        render_article(@article)
      else
        render json: { errors: { body: @article.errors } }, status: :unprocessable_entity
      end
    end

    def show
      render_article(@article)
    end

    def update
      render_unauthorized and return unless owner?(@article)

      if @article.update(article_params.except(:tagList))
        @article.sync_tags(article_params[:tagList])
        render_article(@article)
      else
        render json: @article.errors, status: :unprocessable_entity
      end
    end

    def destroy
      render_unauthorized and return unless owner?(@article)

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
      render json: { article: { slug: article.slug, title: article.title, description: article.description,
                                body: article.body, tagList: article.tags.pluck(:name), createdAt: article.created_at, updatedAt: article.updated_at, favorited: article.users.include?(@current_user), favoritesCount: article.users.count, author: article.user.attributes.slice('username', 'bio', 'image').merge({ following: true }) } } # rubocop:disable Layout/LineLength
    end
  end
end
