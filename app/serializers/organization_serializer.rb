class OrganizationSerializer < ActiveModel::Serializer
  attributes  :name, :description, :street_1, :street_2, :city, :state, :postal_code,
              :country, :phone, :phone_ext, :email, :url, :hashed_identifier
end
