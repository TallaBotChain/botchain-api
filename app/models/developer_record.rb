class DeveloperRecord < ApplicationRecord
  has_many :developers
  has_many :ethereum_transactions, as: :ownerable, dependent: :destroy

  before_save :save_hashed_identifier

  def save_hashed_identifier
    self.hashed_identifier = generate_hashed_identifier
  end

  def generate_hashed_identifier
    new_attributes = self.attributes
    new_attributes.delete('id')
    new_attributes.delete('created_at')
    new_attributes.delete('updated_at')
    new_attributes.delete('hashed_identifier')
    new_attributes.delete('approved')
    Digest::SHA256.hexdigest(new_attributes.to_json)
  end
end
