module V1
  class OrganizationsController < ApplicationController
    def show
      @organization = Organization.find(params[:id])
      render json: @organization
    end

    def update
    end

    def create
    end

  end
end
