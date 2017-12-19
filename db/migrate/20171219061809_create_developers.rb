class CreateDevelopers < ActiveRecord::Migration[5.1]
  def change
    create_table :developers do |t|
      t.bigint :developer_record_id
      t.text :eth_address
      t.boolean :owner, default: false
      t.timestamps
    end
  end
end
