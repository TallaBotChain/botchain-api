module V1
  class BotsController < ApplicationController
    before_action :authenticate, except: [:show, :identity_verification, :search]

    def show
      @developer = Developer.find_by(eth_address: params[:eth_address])
      if @developer.andand.bots.present?
        render json: @developer.bots
      else
        render status: 404, json: { message: "Bot not found"}
      end
    end

    def search
      client = Ethereum::HttpClient.new("http://#{ENV['RPC_HOST']}:#{ENV['RPC_PORT']}")
      payment_tx = client.eth_get_transaction_by_hash(params[:botcoin_tx_hash])
      block_hash = payment_tx['result'].andand['blockHash']

      if block_hash.present?
        block = client.eth_get_block_by_hash(payment_tx['result']['blockHash'], false)
        block_unix_timestamp = block['result']['timestamp'].to_i(16)
        if block_unix_timestamp < (DateTime.now - 10.minutes).utc.to_i 
          return render status: 401, json: { success: false, message: "Transaction has expired" }
        end

        encoded_input = payment_tx['result']['input']
        if encoded_input
          params = { abi: JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts/BotCoin.json'))['abi'], encoded_input: encoded_input }
          response = JSON.parse(RestClient::Request.execute(
                              :method => :get,
                              :url => "http://#{ENV['SIGVAL_SVC_HOST']}/decode",
                              :headers => { 
                                :content_type => :json,
                                :accept => :json
                              },
                              :payload => params.to_json
                            ))

          if response['name'] == "transfer"
            if response["params"].first["value"] != ENV["RECIEVE_ETH_ADDRESS"]
              return render status: 401, json: { success: false, message: "Please send BOTC to #{ENV["RECIEVE_ETH_ADDRESS"]}" }
            end

            if response["params"].last["value"] != ENV["SEARCH_BOTCOIN_PRICE_WEI"]
              return render status: 401, json: { success: false, message: "Incorrect BOTC amount" }
            end
          else
            return render status: 401, json: { success: false, message: "Transaction is not an ERC20 transfer" }
          end
        else
          return render status: 401, json: { success: false, message: "Transaction is not an ERC20 transfer" }
        end
      else
        return render status: 401, json: { success: false, message: 'Unconfirmed Transaction' }
      end

      @bots = Bot.basic_search(params[:query])
      if @bots.present?
        render json: @bots
      else
        render status: 404, json: { message: "No Bots matched search query" }
      end
    end

    def update
      @developer = Developer.find_by(eth_address: @eth_address_access)
      @bot = @developer.bots.find_by(hashed_identifier: params[:hashed_identifier])
      if @bot.present?
        @bot.update!(bot_params)
        @ethereum_transaction = @bot.ethereum_transactions.create(tx_hash: params.require(:tx_hash).permit, action_name: 'updateBot')
        render status: 200, json: {
                                    success: true,
                                    hashed_identifier: @bot.hashed_identifier
                                  }
      else
        render status: 404, json: {
                                    success: false,
                                    message: "Bot not found"
                                  }
      end
    end

    def create
      @developer = Developer.find_by(eth_address: @eth_address_access)
      @bot = Bot.new(bot_params)
      @bot.developer = @developer
      @bot.save!
      @ethereum_transaction = @bot.ethereum_transactions.create(tx_hash: params.require(:tx_hash), action_name: 'createBot')
      render status: 200, json: {
                                  success: true,
                                  hashed_identifier: @bot.hashed_identifier,
                                  transaction_hash: @ethereum_transaction.tx_hash
                                }
    end

    def identity_verification
      client = Ethereum::HttpClient.new("http://#{ENV['RPC_HOST']}:#{ENV['RPC_PORT']}")
      payment_tx = client.eth_get_transaction_by_hash(params[:botcoin_tx_hash])
      block_hash = payment_tx['result'].andand['blockHash']

      if block_hash.present?
        block = client.eth_get_block_by_hash(payment_tx['result']['blockHash'], false)
        block_unix_timestamp = block['result']['timestamp'].to_i(16)
        if block_unix_timestamp < (DateTime.now - 10.minutes).utc.to_i 
          return render status: 401, json: { success: false, message: "Transaction has expired" }
        end

        encoded_input = payment_tx['result']['input']
        if encoded_input
          params = { abi: JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts/BotCoin.json'))['abi'], encoded_input: encoded_input }
          response = JSON.parse(RestClient::Request.execute(
                              :method => :get,
                              :url => "http://#{ENV['SIGVAL_SVC_HOST']}/decode",
                              :headers => { 
                                :content_type => :json,
                                :accept => :json
                              },
                              :payload => params.to_json
                            ))

          if response['name'] == "transfer"
            if response["params"].first["value"] != ENV["RECIEVE_ETH_ADDRESS"]
              return render status: 401, json: { success: false, message: "Please send BOTC to #{ENV["RECIEVE_ETH_ADDRESS"]}" }
            end

            if response["params"].last["value"] != ENV["ID_BOTCOIN_PRICE_WEI"]
              return render status: 401, json: { success: false, message: "Incorrect BOTC amount" }
            end
          else
            return render status: 401, json: { success: false, message: "Transaction is not an ERC20 transfer" }
          end
        else
          return render status: 401, json: { success: false, message: "Transaction is not an ERC20 transfer" }
        end
      else
        return render status: 401, json: { success: false, message: 'Unconfirmed Transaction' }
      end

      @response = JSON.parse(RestClient::Request.execute(
                              :method => :get,
                              :url => "http://#{ENV['SIGVAL_SVC_HOST']}/signatures",
                              :headers => { 
                                :content_type => :json,
                                :accept => :json
                              },
                              :payload => params.to_json
                            ))

      if @response["sender"].present?
        @bot = Bot.find_by(eth_address: @response["sender"])
        if @bot.present?
          render json: { success: true, bot: @bot.metadata_url, developer: @bot.developer.metadata_url }
        else
          render status: 404, json: { success: false, message: "Bot with Ethereum Address #{@response["sender"]} not found" }
        end
      else
        render status: 400, json: { success: false, message: "Signature verification failed"}
      end
    end

    private
      def bot_params
        params.require(:bot).permit(:name, :description, :current_version, :eth_address, :hashed_identifier, :tags => [])
      end
  end
end