class AddAttributesToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :street_1, :string
    add_column :organizations, :street_2, :string
    add_column :organizations, :city, :string
    add_column :organizations, :state, :string
    add_column :organizations, :postal_code, :string
    add_column :organizations, :country, :string
    add_column :organizations, :phone, :string
    add_column :organizations, :phone_ext, :string
    add_column :organizations, :email, :string
    add_column :organizations, :url, :string
    add_column :organizations, :approved, :boolean, default: false
  end
end
