class UpdateTableNames < ActiveRecord::Migration[5.1]
  def change
    rename_table :organizations, :developer_records
    drop_table :organization_members
  end
end
