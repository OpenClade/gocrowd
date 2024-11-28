class AddCanAdvanceStateToOfferings < ActiveRecord::Migration[7.1]
  def change
    add_column :offerings, :can_advance_state, :boolean
  end
end
