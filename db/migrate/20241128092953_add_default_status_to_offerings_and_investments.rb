class AddDefaultStatusToOfferingsAndInvestments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :offerings, :status, from: nil, to: 0
    change_column_default :investments, :status, from: nil, to: 0
  end
end
