module V1
  class DeveloperRecordsController < ApplicationController

    before_action :authenticate, except: [:show, :eth_transaction]

    def show
      @developer = Developer.find_by(eth_address:  params[:eth_address])
      @developer_record = @developer.andand.developer_record
      if @developer_record.present?
        render json: @developer_record
      else
        render status: 404, json: { message: "DeveloperRecord not found" }
      end
    end

    def update
      @developer = Developer.find_by(eth_address: @eth_address_access)
      @developer_record = @developer.andand.developer_record
      if @developer_record.present?
        # Call addDeveloper on BotChain contract 
        @developer_record.update!(developer_record_params)
        contract_address = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts.json'))['BotChain']
        abi = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts/BotChain.json'))['abi']
        client = Ethereum::HttpClient.new("http://#{ENV['RPC_HOST']}:#{ENV['RPC_PORT']}")
        contract = Ethereum::Contract.create(name: "BotChain", address: contract_address, abi: abi, client: client)
        transaction = contract.transact.update_developer(developer_record_params[:eth_address], @developer_record.generate_hashed_identifier)
        @developer_record.ethereum_transactions.create(hash: transaction.address, action_name: 'updateDeveloper')

        render status: 200, json: {
                                    success: true,
                                    hashed_identifier: @developer_record.hashed_identifier,
                                    transaction_address: transaction.address,
                                    eth_address: @developer_record.eth_address
                                  }
      else
        render status: 404, json: {
                                    success: false,
                                    message: "DeveloperRecord not found."
                                  }
      end
    end

    def create
      @developer_record = DeveloperRecord.create!(developer_record_params)
      @developer = @developer_record.developers.create!(eth_address: developer_record_params[:eth_address], owner: true)
      # Call addDeveloper on BotChain contract 
      contract_address = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts.json'))['BotChain']
      abi = JSON.parse(RestClient.get('https://s3.amazonaws.com/talla-botchain-dev-abi/contracts/BotChain.json'))['abi']
      client = Ethereum::HttpClient.new("http://#{ENV['RPC_HOST']}:#{ENV['RPC_PORT']}")
      contract = Ethereum::Contract.create(name: "BotChain", address: contract_address, abi: abi, client: client)
      transaction = contract.transact.add_developer(developer_record_params[:eth_address], @developer_record.generate_hashed_identifier)
      @developer_record.ethereum_transactions.create(hash: transaction.address, action_name: 'addDeveloper')

      render status: 200, json: {
                                  success: true,
                                  hashed_identifier: @developer_record.hashed_identifier,
                                  transaction_address: transaction.address,
                                  eth_address: @developer_record.eth_address
                                }
    end

    def eth_transaction
      @developer = Developer.find_by(eth_address: params[:eth_address])
      @developer_record = @developer.andand.developer_record
      if @developer_record.present?
        @ethereum_transaction = @developer_record.ethereum_transactions.where(action_name: params[:action_name]).order(created_at: :desc).first
        if @ethereum_transaction.present?
          render status: 200, json: {
                                      success: true,
                                      transaction_address: @ethereum_transaction.hash,
                                      created_at: @ethereum_transaction.created_at
                                    }
        else
          render status: 404, json: { success: false, message: "Transaction not found" }
        end
      else
        render status: 404, json: { success: false, message: "DeveloperRecord not found" }
      end
    end

    private

      def developer_record_params
        params.require(:developer_record).permit(
          :name, :description, :street_1, :street_2, :city, :state, :postal_code,
          :country, :phone, :phone_ext, :email, :url, :eth_address)
      end

  end
end
