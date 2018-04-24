class Bot < ApplicationRecord
  has_many :ethereum_transactions, as: :ownerable, dependent: :destroy
end
