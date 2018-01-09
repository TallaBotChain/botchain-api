class EthereumTransaction < ApplicationRecord
  enum status: [:in_progress, :succeed, :expired, :failed]

  def check_status
    return unless in_progress?

    # check if transaction is mined
    if eth_client.eth_get_transaction_by_hash(tx_id)["result"]["blockNumber"].present?
      #get transaction receipt - 1 means succeed
      res = eth_client.eth_get_transaction_receipt(tx_id)
      return res["result"]["status"].present? && res["result"]["status"].hex == 1 ? succeed! : failed!
    end

    #check if transaction is expired
    expired! if in_progress? && Time.now > (created_at + 24.hours)
  end

  private

  def eth_client
    unless @client
      @client = Ethereum::HttpClient.new(Rails.application.config.x.geth_rpc_url)
    end
    return @client
  end
end
