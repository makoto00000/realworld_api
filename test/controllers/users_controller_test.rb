require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should create user" do
    assert_difference 'User.count', 1 do
      post api_users_path, params: { user: { username: "Example User",
                                             email:"user@example.com",
                                             password: "password"} }
      assert_response :created
    end
  end

  test "should not create user with invalid input" do
    assert_no_difference 'User.count' do
      post api_users_path, params: { user: { username: "",
                                             email:"",
                                             password: ""} }
      assert_response :unprocessable_entity
    end
  end

  test "should login" do
    post api_users_login_path, params: { user: { username: "Michael Example",
                                                 email:"michael@example.com",
                                                 password: "password"} }
    assert_response :ok
  end

  test "should not login with invalid email" do
    post api_users_login_path, params: { user: { username: "Michael Example",
                                                 email:"invalid@example.com",
                                                 password: "password"} }
    assert_response :unauthorized
  end

  test "should not login with invalid password" do
    post api_users_login_path, params: { user: { username: "Michael Example",
                                                 email:"michael@example.com",
                                                 password: "invalid"} }
    assert_response :unauthorized
  end
end
