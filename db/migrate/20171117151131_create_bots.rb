class CreateBots < ActiveRecord::Migration[5.1]
  def change
    create_table :bots do |t|
      t.belongs_to :organization, index: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
