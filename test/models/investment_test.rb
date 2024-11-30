# test/models/investment_test.rb
require "test_helper"

class InvestmentTest < ActiveSupport::TestCase
  setup do
    @investment = investments(:one)
  end

  test "should be valid with valid attributes" do
    assert @investment.valid?
  end

  test "should not be valid without amount" do
    @investment.amount = nil
    assert_not @investment.valid?
  end

  test "should not be valid without status" do
    @investment.status = nil
    assert_not @investment.valid?
  end

  test "should belong to investor" do
    assert @investment.investor.present?
  end

  test "should belong to offering" do
    assert @investment.offering.present?
  end

  test "should validate offering is open" do
    @investment.offering.status = 'closed'
    assert_not @investment.valid?
    assert_includes @investment.errors[:offering], 'is not open'
  end

  test "should validate amount within limits" do
    @investment.amount = @investment.offering.min_target - 1
    assert_not @investment.valid?
    assert_includes @investment.errors[:amount], 'is below the minimum investment'

    @investment.amount = @investment.offering.max_target + 1
    assert_not @investment.valid?
    assert_includes @investment.errors[:amount], 'exceeds the maximum investment'
  end

  test "should validate investor KYC approved" do
    @investment.investor.kyc_status = 'pending'
    assert_not @investment.valid?
    assert_includes @investment.errors[:investor], 'KYC not approved'
  end
end