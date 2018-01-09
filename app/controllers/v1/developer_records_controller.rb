module V1
  class DeveloperRecordsController < ApplicationController

    before_action :authenticate, except: [:show]

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
        abi = [] # Expose ABI via S3
        client = Ethereum::IpcClient.new("~/.parity/mycustom.ipc", false) # Replace with real ipc file
        contract = Ethereum::Contract.create(name: "BotChain", address: ENV['BOTCHAIN_CONTRACT_ADDRESS'], abi: abi)
        transaction = contract.transact.update_developer(developer_record_params[:eth_address], @developer_record.generate_hashed_identifier)
        @developer_record.developer_record_transactions.create(tx_id: transaction.id)
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
      abi = [] # Expose ABI via S3
      client = Ethereum::IpcClient.new("~/.parity/mycustom.ipc", false) # Replace with real ipc file
      contract = Ethereum::Contract.create(name: "BotChain", address: ENV['BOTCHAIN_CONTRACT_ADDRESS'], abi: abi)
      transaction = contract.transact.add_developer(developer_record_params[:eth_address], @developer_record.generate_hashed_identifier)
      render status: 200, json: {
                                  success: true,
                                  hashed_identifier: @developer_record.hashed_identifier,
                                  transaction_address: transaction.address,
                                  eth_address: @developer_record.eth_address
                                }
    end

    private

      def developer_record_params
        params.require(:developer_record).permit(
          :name, :description, :street_1, :street_2, :city, :state, :postal_code,
          :country, :phone, :phone_ext, :email, :url, :eth_address)
      end

  end
end
