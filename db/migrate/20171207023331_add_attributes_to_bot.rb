class AddAttributesToBot < ActiveRecord::Migration[5.1]
  def change
    add_column :bots, :approved, :boolean, default: false
    add_column :bots, :tags, :text, array: true, default: []
    add_column :bots, :current_version, :string
    add_column :bots, :eth_address, :text
  end
end
