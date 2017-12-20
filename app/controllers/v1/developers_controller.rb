module V1
  class DevelopersController < ApplicationController

    before_action :authenticate

    def create
      @authed_developer = Developer.find_by(eth_address: @eth_address_access)
      if @authed_developer.owner
        @developer = Developer.find_by(eth_address: developer_params[:eth_address])
        if @developer.present?
          @developer.update!(developer_params)
        else
          @developer = Developer.create!(developer_params)
        end
      else
        return render status: 401, json: { success: false, message: 'Only owners can create developers' }
      end

      render status: 200, json: {
                                  success: true,
                                  eth_address: @developer.eth_address,
                                  owner: @developer.owner
                                }
    end

    def destroy
      Developer.where(eth_address: developer_params[:eth_address]).destroy_all
      render status: 200, json: { success: true }
    end

    private

      def developer_params
        params.require(:developer).permit(:eth_address, :owner)
      end

  end
end