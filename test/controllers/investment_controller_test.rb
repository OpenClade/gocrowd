# test/controllers/investments_controller_test.rb
require "test_helper"

class InvestmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @investment = investments(:two)
    @investor = investors(:one)
    @offering = offerings(:two)
    @user = users(:one)
    @headers = { Authorization: "Bearer #{JWT.encode({ user_id: @user.id }, ENV['SECRET_KEY'])}" }
  end

  test "should get index" do
    get investments_url, headers: @headers
    assert_response :success
  end

  test "should show investment" do
    get investment_url(@investment), headers: @headers
    assert_response :not_found
  end

  test "should create investment" do
     
    post investments_url, params: {investment: {offering_id: @offering.id, amount: 100000, status: 'pending' }}, headers: @headers
   

    assert_response :created
  end

  test "should not create investment with invalid data" do
    post investments_url, params: { investment: { offering_id: nil, amount: nil, status: nil } }, headers: @headers
    assert_response :bad_request
  end

  test "should update investment" do
    patch investment_url(@investment), params: { investment: { amount: 2000, status: 'confirmed' } }, headers: @headers
    assert_response :not_found
  end

  test "should not update investment with invalid data" do
    patch investment_url(@investment), params: { investment: { amount: nil, status: nil } }, headers: @headers
    assert_response :not_found
  end

  test "should upload bank statement" do
    file = fixture_file_upload(Rails.root.join('test', 'fixtures', 'files', 'bank_statement.pdf'), 'application/pdf')
    post upload_bank_statement_investment_url(@investment), params: { file: file }, headers: @headers
    assert_response :ok
  end
end