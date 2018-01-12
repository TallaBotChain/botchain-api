class CreateEthereumTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :ethereum_transactions do |t|
      t.text :hash
      t.integer :ownerable_id
      t.string :ownerable_type
      t.string :action_name
      t.timestamps
    end
  end
end
