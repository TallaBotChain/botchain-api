module V1
  class BotsController < ApplicationController
    before_action :authenticate, except: [:show]

    def show
      @developer = Developer.find_by(eth_address: params[:eth_address])
      if @developer.andand.bots.present?
        render json: @developer.bots
      else
        render status: 404, json: { message: "Bot not found"}
      end
    end

    def search
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

    private
      def bot_params
        params.require(:bot).permit(:name, :description, :current_version, :eth_address, :hashed_identifier, :tags => [])
      end
  end
end