class AddMetadataUrlToBotsAndDevelopers < ActiveRecord::Migration[5.1]
  def change
    add_column :developer_records, :metadata_url, :text
    add_column :bots, :metadata_url, :text
  end
end
