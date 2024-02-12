# frozen_string_literal: true

require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  test 'should get all tags' do
    get api_tags_path
    assert_response :ok
    assert_equal(3, Tag.count)
  end
end
