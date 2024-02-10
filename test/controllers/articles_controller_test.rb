# frozen_string_literal: true

require 'test_helper'

class ArticlesControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @article = articles(:article1)
    @token = create_token(@user.id)
    @other_token = create_token(@other_user.id)
  end

  # test for show
  test 'should not get article not logged in user' do
    get api_article_path(@article.slug)
    assert_response :unauthorized
  end

  test 'should get article logged in user' do
    get api_article_path(@article.slug), headers: { 'Authorization' => "Bearer #{@token}" }
    assert_response :ok
  end

  test 'should get article logged in other user' do
    get api_article_path(@article.slug), headers: { 'Authorization' => "Bearer #{@other_token}" }
    assert_response :ok
  end

  # test for create
  test 'should not post article not logged in user' do
    post api_articles_path, params: { article: { title: 'test title',
                                                 description: 'test description',
                                                 body: 'test body',
                                                 tagList: %w[html css ruby] } }
    assert_response :unauthorized
  end

  test 'should post article logged in user' do
    assert_difference 'Article.count', 1 do
      assert_difference 'Tag.count', 1 do
        post api_articles_path, headers: { 'Authorization' => "Bearer #{@other_token}" },
                                params: { article: { title: 'test title',
                                                     description: 'test description',
                                                     body: 'test body',
                                                     tagList: %w[html css ruby] } }
        assert_response :ok
      end
    end
  end

  # test for update
  test 'should not update not logged in user' do
    put api_article_path(@article.slug), params: { article: { title: 'Test Article Update',
                                                              description: 'test description updated',
                                                              body: 'test body updated' } }
    assert_response :unauthorized
  end

  test 'should update article logged in owner user' do
    put api_article_path(@article.slug), headers: { 'Authorization' => "Bearer #{@token}" },
                                         params: { article: { title: 'Test Article Update',
                                                              description: 'test description updated',
                                                              body: 'test body updated' } }
    assert_response :ok
    article = controller.instance_variable_get('@article')
    get api_article_path(article.slug), headers: { 'Authorization' => "Bearer #{@token}" }
    assert_response :ok
  end

  test 'should not update article logged in other user' do
    put api_article_path(@article.slug), headers: { 'Authorization' => "Bearer #{@other_token}" },
                                         params: { article: { title: 'Test Article Update',
                                                              description: 'test description updated',
                                                              body: 'test body updated' } }
    assert_response :unauthorized
  end

  # test for dertroy
  test 'should not destroy article not logged in user' do
    delete api_article_path(@article.slug)
    assert_response :unauthorized
  end

  test 'should destroy article logged in owner user' do
    delete api_article_path(@article.slug), headers: { 'Authorization' => "Bearer #{@token}" }
    assert_response :no_content
  end

  test 'should destroy article logged in other user' do
    delete api_article_path(@article.slug), headers: { 'Authorization' => "Bearer #{@other_token}" }
    assert_response :unauthorized
  end

  # test for favorite
  test 'should not favorite article not logged in user' do
    post "/api/articles/#{@article.slug}/favorite"
    assert_response :unauthorized
  end

  test 'should favorite article logged in user' do
    assert_difference '@article.users.count', 1 do
      post "/api/articles/#{@article.slug}/favorite", headers: { 'Authorization' => "Bearer #{@token}" }
      assert_response :ok
    end
  end

  test 'should favorite article logged in other user' do
    assert_difference '@article.users.count', 1 do
      post "/api/articles/#{@article.slug}/favorite", headers: { 'Authorization' => "Bearer #{@other_token}" }
      assert_response :ok
    end
  end

  test 'should not unfavorite article not logged in user' do
    delete "/api/articles/#{@article.slug}/favorite"
    assert_response :unauthorized
  end

  test 'should unfavorite article logged in user' do
    post "/api/articles/#{@article.slug}/favorite", headers: { 'Authorization' => "Bearer #{@token}" }
    assert_difference '@article.users.count', -1 do
      delete "/api/articles/#{@article.slug}/favorite", headers: { 'Authorization' => "Bearer #{@token}" }
      assert_response :ok
    end
  end

  test 'should unfavorite article logged in other user' do
    post "/api/articles/#{@article.slug}/favorite", headers: { 'Authorization' => "Bearer #{@other_token}" }
    assert_difference '@article.users.count', -1 do
      delete "/api/articles/#{@article.slug}/favorite", headers: { 'Authorization' => "Bearer #{@other_token}" }
      assert_response :ok
    end
  end
end
