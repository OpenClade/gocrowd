# test/models/offering_test.rb
require "test_helper"

class OfferingTest < ActiveSupport::TestCase
  setup do
    @offering = offerings(:one)
  end

  test "should be valid with valid attributes" do
    assert @offering.valid?
  end

  test "should not be valid without name" do
    @offering.name = nil
    assert_not @offering.valid?
  end

  test "should not be valid without status" do
    @offering.status = nil
    assert_not @offering.valid?
  end

  test "should have many investments" do
    assert @offering.investments.any?
  end
end