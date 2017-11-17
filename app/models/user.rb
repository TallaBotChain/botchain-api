class User < ActiveRecord::Base
  has_many :organization_members
  has_many :organizations, through: :organization_members

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable

  include DeviseTokenAuth::Concerns::User

end
