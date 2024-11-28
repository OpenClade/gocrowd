# test/controllers/users_controller_test.rb
require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: 'hello@example.com', password: 'password', role: 'user' } }
    end

    assert_response :created
  end

  test "should not create user with invalid data" do
    post users_url, params: { user: { email: nil, password: nil } }
    assert_response :unprocessable_entity
  end

  test "should show current user" do
    get me_url, headers: { Authorization: "Bearer #{JWT.encode({ user_id: @user.id }, 'hellomars1211')}" }
    assert_response :success
  end
end