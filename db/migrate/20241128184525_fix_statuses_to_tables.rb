class FixStatusesToTables < ActiveRecord::Migration[7.1]
  def up
    # Add new columns with the desired type
    add_column :investments, :status_temp, :integer, default: 0
    add_column :offerings, :status_temp, :integer, default: 0

    # Copy data from the old columns to the new columns
    execute <<-SQL
      UPDATE investments
      SET status_temp = CASE
        WHEN status = 'pending' THEN 0
        WHEN status = 'signed' THEN 1
        WHEN status = 'confirmed' THEN 2
        WHEN status = 'received' THEN 3
        WHEN status = 'hidden' THEN 4
        ELSE 0
      END
    SQL

    execute <<-SQL
      UPDATE offerings
      SET status_temp = CASE
        WHEN status = 'draft' THEN 0
        WHEN status = 'collecting' THEN 1
        WHEN status = 'closed' THEN 2
        WHEN status = 'completed' THEN 3
        ELSE 0
      END
    SQL

    # Remove the old columns
    remove_column :investments, :status
    remove_column :offerings, :status

    # Rename the new columns to the old column names
    rename_column :investments, :status_temp, :status
    rename_column :offerings, :status_temp, :status
  end

  def down
    # Add the old columns back with the original type
    add_column :investments, :status_temp, :string
    add_column :offerings, :status_temp, :string

    # Copy data from the new columns to the old columns
    execute <<-SQL
      UPDATE investments
      SET status_temp = CASE
        WHEN status = 0 THEN 'pending'
        WHEN status = 1 THEN 'signed'
        WHEN status = 2 THEN 'confirmed'
        WHEN status = 3 THEN 'received'
        WHEN status = 4 THEN 'hidden'
        ELSE 'pending'
      END
    SQL

    execute <<-SQL
      UPDATE offerings
      SET status_temp = CASE
        WHEN status = 0 THEN 'draft'
        WHEN status = 1 THEN 'collecting'
        WHEN status = 2 THEN 'closed'
        WHEN status = 3 THEN 'completed'
        ELSE 'draft'
      END
    SQL

    # Remove the new columns
    remove_column :investments, :status
    remove_column :offerings, :status

    # Rename the old columns back to the original names
    rename_column :investments, :status_temp, :status
    rename_column :offerings, :status_temp, :status
  end
end