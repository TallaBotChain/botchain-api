class Organization < ApplicationRecord
  has_many :organization_members
  has_many :users, through: :organization_members
  has_many :bots
end
