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

    def update
      @developer = Developer.find_by(eth_address: @eth_address_access)
      @bot = @developer.bots.find_by(hashed_identifier: params[:hashed_identifier])
      if @bot.present?
        @bot.update!(bot_params)
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
      render status: 200, json: {
                                  success: true,
                                  hashed_identifier: @bot.hashed_identifier
                                }
    end

    private
      def bot_params
        params.require(:bot).permit(:name, :description, :tags, :current_version, :eth_address, :hashed_identifier)
      end
  end
end