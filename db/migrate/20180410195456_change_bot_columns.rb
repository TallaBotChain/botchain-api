class ChangeBotColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :bots, :name, :bot_name
    rename_column :bots, :description, :bot_description
    rename_column :bots, :tags, :bot_tags
  end
end
