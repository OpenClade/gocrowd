class AddColumnToTable < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :unpublished, :boolean
  end
end
