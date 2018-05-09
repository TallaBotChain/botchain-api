class BotSyncWorker
  include Sidekiq::Worker 

  def perform
    # Setup
    contract_address = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts.json'))['BotProductRegistry']
    abi = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts/BotProductRegistryDelegate.json'))['abi']
    client = Ethereum::HttpClient.new("http://#{ENV['RPC_HOST']}:#{ENV['RPC_PORT']}")
    contract = Ethereum::Contract.create(name: "BotProductRegistry", address: contract_address, abi: abi, client: client)

    # Fetch and sync all Bots
    bot_count = contract.call.total_supply
    (1..bot_count).each do |index|
      bot_url = contract.call.bot_entry_url(index)
      next if bot_url.empty?
      bot_developer_eth_address = "0x#{contract.call.get_bot_entry(index).andand[0]}"
      bot_eth_address = "0x#{contract.call.get_bot_entry(index).andand[1]}"
      begin
        bot_metadata = JSON.parse(RestClient.get(bot_url).delete(160.chr+194.chr))
      rescue
        next
      end
      bot_metadata.select! {|k, v| Bot.column_names.include?(k) }
      bot_metadata["bot_tags"] = bot_metadata["bot_tags"].split(/\s*,\s*/)
      existing_bot = Bot.find_by(eth_address: contract.call.get_bot_entry(index).andand[1])
      existing_bot_developer = Developer.find_or_create_by(eth_address: bot_developer_eth_address)
      if existing_bot.present?
        existing_bot.update(bot_metadata)
        existing_bot.update(developer_id: existing_bot_developer.id, eth_address: bot_eth_address)
        existing_bot.update(metadata_url: bot_url)
      else
        new_bot = Bot.create!(bot_metadata)
        new_bot.update(developer_id: existing_bot_developer.id, eth_address: bot_eth_address)
        new_bot.update(metadata_url: bot_url)
      end
    end
  end
end