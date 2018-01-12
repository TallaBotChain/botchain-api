module V1
  class AuthController < ApplicationController

    def access_token
      @response = JSON.parse(RestClient::Request.execute(
                              :method => :get,
                              :url => "http://#{ENV['SIGVAL_SVC_HOST']}/signatures",
                              :headers => { 
                                :content_type => :json,
                                :accept => :json
                              },
                              :payload => params.to_json
                            ))

      if @response["sender"].present? && @response["sender"] == params["eth_address"]
        @access_token = JWT.encode({eth_address: @response["sender"]}, ENV['ACCESS_TOKEN_HMAC_SECRET'], 'HS256')
        render status: 200, json: { success: true, access_token: @access_token, eth_address: @response["sender"] }
      else
        render status: 401, json: { success: false, message: "Signature verification failed"}
      end
      
    end

  end
end
