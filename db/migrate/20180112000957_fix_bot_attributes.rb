class FixBotAttributes < ActiveRecord::Migration[5.1]
  def change
    rename_column :bots, :organization_id, :developer_id
  end
end
