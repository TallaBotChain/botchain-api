class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :ethereum_transactions, :hash, :tx_hash
  end
end
