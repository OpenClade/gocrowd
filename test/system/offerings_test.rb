require "application_system_test_case"

class OfferingsTest < ApplicationSystemTestCase
  setup do
    @offering = offerings(:one)
  end

  test "visiting the index" do
    visit offerings_url
    assert_selector "h1", text: "Offerings"
  end

  test "should create offering" do
    visit offerings_url
    click_on "New offering"

    fill_in "Current reserved amount", with: @offering.current_reserved_amount
    fill_in "Funded amount", with: @offering.funded_amount
    fill_in "Max target", with: @offering.max_target
    fill_in "Min invest amount", with: @offering.min_invest_amount
    fill_in "Min target", with: @offering.min_target
    fill_in "Name", with: @offering.name
    fill_in "Reserved investors", with: @offering.reserved_investors
    fill_in "State", with: @offering.state
    fill_in "Total investors", with: @offering.total_investors
    fill_in "Type", with: @offering.type
    click_on "Create Offering"

    assert_text "Offering was successfully created"
    click_on "Back"
  end

  test "should update Offering" do
    visit offering_url(@offering)
    click_on "Edit this offering", match: :first

    fill_in "Current reserved amount", with: @offering.current_reserved_amount
    fill_in "Funded amount", with: @offering.funded_amount
    fill_in "Max target", with: @offering.max_target
    fill_in "Min invest amount", with: @offering.min_invest_amount
    fill_in "Min target", with: @offering.min_target
    fill_in "Name", with: @offering.name
    fill_in "Reserved investors", with: @offering.reserved_investors
    fill_in "State", with: @offering.state
    fill_in "Total investors", with: @offering.total_investors
    fill_in "Type", with: @offering.type
    click_on "Update Offering"

    assert_text "Offering was successfully updated"
    click_on "Back"
  end

  test "should destroy Offering" do
    visit offering_url(@offering)
    click_on "Destroy this offering", match: :first

    assert_text "Offering was successfully destroyed"
  end
end
