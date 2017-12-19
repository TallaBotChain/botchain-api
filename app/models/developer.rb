class Developer < ApplicationRecord
  belongs_to :developer_record

  validates :eth_address, uniqueness: { scope: [:developer_record_id] }
end
