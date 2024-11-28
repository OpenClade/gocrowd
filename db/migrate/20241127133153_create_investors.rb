class CreateInvestors < ActiveRecord::Migration[7.1]
  def change
    create_table :investors do |t|
      t.references :user, null: false, foreign_key: true
      t.string :kyc_status
      t.datetime :kyc_verified_at

      t.timestamps
    end
  end
end
