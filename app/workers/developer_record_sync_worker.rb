class DeveloperRecordSyncWorker
  include Sidekiq::Worker 

  def perform
    # Setup
    contract_address = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts.json'))['DeveloperRegistry']
    abi = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts/DeveloperRegistryDelegate.json'))['abi']
    client = Ethereum::HttpClient.new("http://#{ENV['RPC_HOST']}:#{ENV['RPC_PORT']}")
    contract = Ethereum::Contract.create(name: "DeveloperRegistry", address: contract_address, abi: abi, client: client)

    # Fetch and sync all DeveloperRecords
    developer_count = contract.call.total_supply
    (1..developer_count).each do |index|
      developer_record_url = contract.call.developer_url(index)
      developer_record = JSON.parse(RestClient.get(developer_record_url))
      existing_developer_record = DeveloperRecord.find_by(eth_address: developer_record['eth_address'])
      if existing_developer_record.present?
        existing_developer_record.update(developer_record)
        existing_developer_record.update(metadata_url: developer_record_url)
      else
        new_developer = DeveloperRecord.create(developer_record)
        new_developer.update(metadata_url: developer_record_url)
      end
    end
  end
end
