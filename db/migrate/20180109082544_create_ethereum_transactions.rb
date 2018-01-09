class CreateEthereumTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :ethereum_transactions do |t|
      t.string :type, null: false, index: true
      t.string :tx_id, null: false
      t.string :eth_address, null: false, index: true
      t.integer :status, null: false, default: 0
      t.text :data
      t.timestamps
    end
  end
end
