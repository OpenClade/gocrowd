# test/controllers/auth_controller_test.rb
require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should login user" do
    post auth_login_url, params: { auth: { email: @user.email, password: 'password' } }
    assert_response :accepted
  end

  test "should not login user with invalid credentials" do
    post auth_login_url, params: { auth: { email: @user.email, password: 'wrongpassword' } }
    assert_response :unauthorized
  end
end