class CreateInvestments < ActiveRecord::Migration[7.1]
  def change
    create_table :investments do |t|
      t.references :investor, null: false, foreign_key: true
      t.references :offering, null: false, foreign_key: true
      t.decimal :amount
      t.string :status
      t.datetime :signed_at
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
