class BotSerializer < ActiveModel::Serializer
  attributes  :name, :description, :tags, :current_version
end
