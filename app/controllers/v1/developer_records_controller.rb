module V1
  class DeveloperRecordsController < ApplicationController
    def show
      @developer_record = DeveloperRecord.find_by(hashed_identifier: params[:hashed_identifier])
      if @developer_record.present?
        render json: @developer_record
      else
        render status: 404, json: { message: "DeveloperRecord not found" }
      end
    end

    def update
      @developer_record = DeveloperRecord.find_by(hashed_identifier: params[:hashed_identifier])
      if @developer_record.present?
        @developer_record.update!(developer_record_params)
        render status: 200, json: {
                                    success: true,
                                    hashed_identifier: @developer_record.hashed_identifier,
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
      @access_token = JWT.encode({eth_address: @developer.eth_address}, ENV['ACCESS_TOKEN_HMAC_SECRET'], 'HS256')
      render status: 200, json: {
                                  success: true,
                                  hashed_identifier: @developer_record.hashed_identifier,
                                  eth_address: @developer_record.eth_address,
                                  access_token: @access_token
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
