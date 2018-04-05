class AddDeveloperEthAddressToBot < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :developer_eth_address, :text
  end
end
