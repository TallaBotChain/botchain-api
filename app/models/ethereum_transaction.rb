class EthereumTransaction < ApplicationRecord
  belongs_to :ownerable, polymorphic: true
end
