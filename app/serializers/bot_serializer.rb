class BotSerializer < ActiveModel::Serializer
  attributes  :name, :description, :tags, :current_version, :eth_address, :hashed_identifier
end
