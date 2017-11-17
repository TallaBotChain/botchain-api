class CreateOrganizationMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_members do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
