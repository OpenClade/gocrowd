class AddTargetAmountToOfferings < ActiveRecord::Migration[7.1]
  def change
    add_column :offerings, :target_amount, :integer
  end
end
