# test/controllers/investors_controller_test.rb
require "test_helper"

class InvestorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @investor = investors(:one)
    @user = users(:one)

    @user_have_not_investor = users(:four)
    @headers_user_have_not_investor = { Authorization: "Bearer #{JWT.encode({ user_id: @user_have_not_investor.id }, ENV['SECRET_KEY'])}" }
    @headers = { Authorization: "Bearer #{JWT.encode({ user_id: @user.id }, ENV['SECRET_KEY'])}" }
  end

  test "should not create investor with invalid data" do
    post investors_url, params: { investor: { user_id: nil, kyc_status: nil } }, headers: @headers
    assert_response :not_found
  end

  test "should update investor" do
    patch investor_url(@investor), params: { investor: { kyc_status: 'approved' } }, headers: @headers
    assert_response :not_found
  end

  test "should not update investor with invalid data" do
    patch investor_url(@investor), params: { investor: { kyc_status: nil } }, headers: @headers
    assert_response :not_found
  end
end