class Bot < ApplicationRecord
  belongs_to :developer
  has_many :ethereum_transactions, as: :ownerable, dependent: :destroy
end
