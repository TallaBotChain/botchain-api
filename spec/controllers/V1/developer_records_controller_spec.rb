require 'rails_helper'

RSpec.describe V1::DeveloperRecordsController, type: :controller do

  describe 'create, update, and show org by hashed_identifier' do 
    let(:create_params) {
      {
        developer_record: {
          name: "Talla Inc",
          description: "Example developer",
          street_1: "1 Rocket Road",
          city: "Hawthorne",
          state: "CA",
          postal_code: "92830",
          country: "United States of America",
          phone: "838-938-9283",
          email: "admin@talla.com",
          eth_address: "0x6818FAe9c430b5eda1BeD7359A11846499F330c1"
        }
      }
    }
    before(:each) do
      post :create, params: create_params
    end

    let(:original_hashed_identifier) { JSON.parse(response.body)["hashed_identifier"]}
    let(:original_eth_address) { create_params["eth_address"] }

    it 'responds with hashed_identifier on create' do
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(200) 
      expect(response_body["eth_address"]).to eq(create_params[:developer_record][:eth_address])
    end

    it 'responds with developer_record if passed correct eth_address on show' do 
      get :show, params: { eth_address: original_eth_address }
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response_body["name"]).to eq(create_params[:developer_record][:name])
      expect(response_body["description"]).to eq(create_params[:developer_record][:description])
      expect(response_body["street_1"]).to eq(create_params[:developer_record][:street_1])
      expect(response_body["city"]).to eq(create_params[:developer_record][:city])
      expect(response_body["state"]).to eq(create_params[:developer_record][:state])
      expect(response_body["postal_code"]).to eq(create_params[:developer_record][:postal_code])
      expect(response_body["country"]).to eq(create_params[:developer_record][:country])
      expect(response_body["phone"]).to eq(create_params[:developer_record][:phone])
      expect(response_body["email"]).to eq(create_params[:developer_record][:email])
      expect(response_body["eth_address"]).to eq(create_params[:developer_record][:eth_address])
    end

    it 'responds with new hashed_identifier on update' do 
      update_params = {
                        "eth_address": original_eth_address,
                        "developer_record": {
                          "name": "New Name",
                        }
                      }
      put :update, params: update_params
      response_body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(response_body["success"]).to eq(true)
      expect(response_body["eth_address"]).to eq(create_params[:developer_record][:eth_address])
      expect(response_body["hashed_identifier"]).to_not eq(original_hashed_identifier)
    end
  end

end
