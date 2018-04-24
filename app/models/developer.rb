class Developer < ApplicationRecord
  has_many :bots

  validates :eth_address, uniqueness: { scope: [:developer_record_id] }
end
