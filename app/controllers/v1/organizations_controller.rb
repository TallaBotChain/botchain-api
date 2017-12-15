module V1
  class OrganizationsController < ApplicationController
    def show
      @organization = Organization.find_by(hashed_identifier: params[:hashed_identifier])
      if @organization.present?
        render json: @organization
      else
        render status: 404, json: { message: "Hashed identifier not found" }
      end
    end

    def update
      @organization = Organization.find_by(hashed_identifier: params[:hashed_identifier])
      if @organization.present?
        @organization.update!(organization_params)
        render status: 200, json: {
                                    success: true,
                                    hashed_identifier: @organization.hashed_identifier,
                                    eth_address: @organization.eth_address
                                  }
      else
        render status: 404, json: {
                                    success: false,
                                    message: "Organization not found."
                                  }
      end
    end

    def create
      @organization = Organization.create!(organization_params)
      render status: 200, json: {
                                  success: true,
                                  hashed_identifier: @organization.hashed_identifier,
                                  eth_address: @organization.eth_address
                                }
    end

    private

      def organization_params
        params.require(:organization).permit(
          :name, :description, :street_1, :street_2, :city, :state, :postal_code,
          :country, :phone, :phone_ext, :email, :url, :eth_address)
      end

  end
end
