module Auth
  class AccessToken

    def initialize(access_token)
      @access_token = access_token
    end

    def eth_address
      decoded_token = JWT.decode(@access_token, ENV['ACCESS_TOKEN_HMAC_SECRET'], true, { :algorithm => 'HS256' })
      decoded_token.first["eth_address"]
    rescue 
      false
    end

  end
end