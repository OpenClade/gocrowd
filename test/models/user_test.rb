# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should not be valid without email" do
    @user.email = nil
    assert_not @user.valid?
  end

  test "should not be valid with invalid email format" do
    @user.email = "invalid_email"
    assert_not @user.valid?
  end

  test "should have secure password" do
    assert @user.authenticate("password")
  end
end