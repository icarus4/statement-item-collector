class RemoveStatementIdAndAddHasValueToItems < ActiveRecord::Migration
  def change
    remove_column :items, :statement_id
    add_column :items, :has_value, :boolean
    add_index :items, :has_value
  end
end
