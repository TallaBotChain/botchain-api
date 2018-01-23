class BotSerializer < ActiveModel::Serializer
  attributes  :name, :description, :tags, :current_version, :eth_address, :hashed_identifier, :latest_transaction_address, :latest_transaction_action, :developer_record_hashed_identifier

  def latest_transaction_address
    transaction = object.ethereum_transactions.order(created_at: :desc).first
    transaction.andand.tx_hash
  end

  def latest_transaction_action
    transaction = object.ethereum_transactions.order(created_at: :desc).first
    transaction.andand.action_name
  end

  def developer_record_hashed_identifier
    object.developer.andand.developer_record.andand.hashed_identifier
  end
end
