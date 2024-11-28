# test/controllers/offerings_controller_test.rb
require "test_helper"

class OfferingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @offering = offerings(:one)
  end

  test "should get index" do
    get offerings_url
    assert_response :success
  end

  test "should show offering" do
    get offering_url(@offering)
    assert_response :success
  end 
end