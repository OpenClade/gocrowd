class CreateOfferings < ActiveRecord::Migration[7.1]
  def change
    create_table :offerings do |t|
      t.string :type
      t.string :state
      t.string :name
      t.integer :min_invest_amount
      t.integer :min_target
      t.integer :max_target
      t.integer :total_investors
      t.integer :current_reserved_amount
      t.integer :funded_amount
      t.integer :reserved_investors

      t.timestamps
    end
  end
end
