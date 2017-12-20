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
      @authed_developer = Developer.find_by(eth_address: @eth_address_access)
      if @authed_developer.owner
        @developer_to_be_deleted = Developer.find_by(eth_address: developer_params[:eth_address])
        if @developer_to_be_deleted.developer_record_id == @authed_developer.developer_record_id
          @developer_to_be_deleted.destroy
          render status: 200, json: { success: true }
        else
          render status: 401, json: { success: false, message: 'Unauthorized' }
        end
      else
        render status: 401, json: { success: false, message: 'Only owners can create developers' }
      end
      
    end

    private

      def developer_params
        params.require(:developer).permit(:eth_address, :owner)
      end

  end
end