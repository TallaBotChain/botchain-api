class ApplicationController < ActionController::API

  private
    def authenticate
      if params[:access_token].present?
        @eth_address_access = ::Auth::AccessToken.new(params[:access_token]).eth_address
        unless @eth_address_access
          render status: 401, json: { success: false, message: 'Invalid access token'}
        end
      else
        render status: 401, json: { success: false, message: 'No access token provided'}
      end
    end
end
