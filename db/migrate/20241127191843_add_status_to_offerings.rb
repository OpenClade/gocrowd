class AddStatusToOfferings < ActiveRecord::Migration[7.1]
  def change
    add_column :offerings, :status, :string
  end
end
