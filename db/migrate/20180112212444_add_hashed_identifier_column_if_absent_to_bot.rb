class AddHashedIdentifierColumnIfAbsentToBot < ActiveRecord::Migration[5.1]
  def change
    unless column_exists? :bots, :hashed_identifier
      add_column :bots, :hashed_identifier, :text
    end
  end
end
