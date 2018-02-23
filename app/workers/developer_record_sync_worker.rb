class DeveloperRecordSyncWorker
  include Sidekiq::Worker 

  def perform
    # Setup
    contract_address = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts.json'))['BotChain']
    abi = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts/BotChain.json'))['abi']
    client = Ethereum::HttpClient.new("http://#{ENV['RPC_HOST']}:#{ENV['RPC_PORT']}")
    contract = Ethereum::Contract.create(name: "BotChain", address: contract_address, abi: abi, client: client)

    # Fetch and sync all DeveloperRecords
    developer_count = contract.call.get_developer_count
    0..developer_count do |index|
      developer_record = contract.call.get_developer(index)
      existing_developer_record = DeveloperRecord.find_by(eth_address: developer_record['eth_address'])
      if existing_developer_record.present?
        existing_developer_record.update(developer_record)
      else
        DeveloperRecord.create(developer_record)
      end
    end
  end
end
