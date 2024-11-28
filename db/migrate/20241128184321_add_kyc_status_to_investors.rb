class AddKycStatusToInvestors < ActiveRecord::Migration[7.1]
  def up
    # Add a new column with the desired type
    add_column :investors, :kyc_status_temp, :integer, default: 0

    # Copy data from the old column to the new column
    execute <<-SQL
      UPDATE investors
      SET kyc_status_temp = CASE
        WHEN kyc_status = 'pending' THEN 0
        WHEN kyc_status = 'approved' THEN 1
        ELSE 0
      END
    SQL

    # Remove the old column
    remove_column :investors, :kyc_status

    # Rename the new column to the old column name
    rename_column :investors, :kyc_status_temp, :kyc_status
  end

  def down
    # Add the old column back with the original type
    add_column :investors, :kyc_status_temp, :string

    # Copy data from the new column to the old column
    execute <<-SQL
      UPDATE investors
      SET kyc_status_temp = CASE
        WHEN kyc_status = 0 THEN 'pending'
        WHEN kyc_status = 1 THEN 'approved'
        ELSE 'pending'
      END
    SQL

    # Remove the new column
    remove_column :investors, :kyc_status

    # Rename the old column back to the original name
    rename_column :investors, :kyc_status_temp, :kyc_status
  end
end