class BotSyncWorker
  include Sidekiq::Worker 

  def perform
    # Setup
    contract_address = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts.json'))['BotChain']
    abi = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts/BotChain.json'))['abi']
    client = Ethereum::HttpClient.new("http://#{ENV['RPC_HOST']}:#{ENV['RPC_PORT']}")
    contract = Ethereum::Contract.create(name: "BotChain", address: contract_address, abi: abi, client: client)

    # Fetch and sync all Bots
    bot_count = contract.call.total_supply
    0..bot_count do |index|
      bot_url = contract.call.get_bot_url(index)
      bot = JSON.parse(RestClient.get(bot_url))
      existing_bot = Bot.find_by(eth_address: bot['eth_address'])
      if existing_bot.present?
        existing_bot.update(bot)
      else
        Bot.create(bot)
      end
    end
  end
end