module V1
  class BotsController < ApplicationController

    def index
      @bots = Bot.where(eth_address: params[:eth_address])
      render status: 200, json: @bots.to_json
    end

    def show
      @bot = Bot.find_by(hashed_identifier: params[:hashed_identifier])
      if @bot.present?
        render json: @bot
      else
        render status: 404, json: { message: "Bot not found"}
      end
    end

    def update
      #TODO add auth
      @bot = Bot.find_by(hashed_identifier: params[:hashed_identifier])
      if @bot.present?
        @bot.update!(bot_params)
        render status: 200, json: {
                                    success: true,
                                    hashed_identifier: @bot.hashed_identifier,
                                    eth_address: @bot.organization.eth_address
                                  }
      else
        render status: 404, json: {
                                    success: false,
                                    message: "Bot not found"
                                  }
      end
    end

    def create
      #Look up Organization with eth_address for now
      #TODO implement:
      #https://hackernoon.com/never-use-passwords-again-with-ethereum-and-metamask-b61c7e409f0d
      @organization = Organization.find_by(eth_address: params[:eth_address])
      if @organization.present?
        @bot = Bot.new(bot_params)
        @bot.organization = @organization
        @bot.save!
        render status: 200, json: {
                                    success: true,
                                    hashed_identifier: @bot.hashed_identifier,
                                    eth_address: @organization.eth_address
                                  }
      else
        render status: 404, json: {
                                    success: false,
                                    message: 'Unidentified organization'
                                  }
      end
    end

    def transfer
      #TODO auth
      @to_organization = Organization.find_by(eth_address: params[:to_eth_address])
      @bot = Bot.find_by(hashed_identifier: params[:hashed_identifier])
      if @to_organization.present? && @bot.present?
        @bot.update!(organization: @to_organization)
        render status: 200, json: {
                                    success: true,
                                    hashed_identifier: @bot.hashed_identifier
                                  }
      else
        render status: 404, json: {
                                    success: false,
                                    message: 'Bot/Organization not found'
                                  }
      end
    end

    private
      def bot_params
        params.require(:bot).permit(:name, :description, :tags, :current_version)
      end
  end
end
