# test/controllers/users_controller_test.rb
require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: 'hello213@example.com', password: 'password', role: 'user' } }
    end

    assert_response :created
  end

  test "should not create user with invalid data" do
    post users_url, params: { user: { email: nil, password: nil } }
    assert_response :unauthorized
  end

  test "should show current user" do
    get users_me_url, headers: { Authorization: "Bearer #{JWT.encode({ user_id: @user.id }, ENV['SECRET_KEY'])}" }
    assert_response :success
  end
end