# test/models/investor_test.rb
require "test_helper"

class InvestorTest < ActiveSupport::TestCase
  setup do
    @investor = investors(:one)
  end

  test "should be valid with valid attributes" do
    assert @investor.valid?
  end

  test "should not be valid without user" do
    @investor.user = nil
    assert_not @investor.valid?
  end

  test "should not be valid without kyc_status" do
    @investor.kyc_status = nil
    assert_not @investor.valid?
  end

  test "should belong to user" do
    assert @investor.user.present?
  end
end