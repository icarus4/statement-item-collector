class AddStatementIdToStatementItems < ActiveRecord::Migration
  def change
    add_column :statement_items, :statement_id, :integer
    add_index :statement_items, :statement_id
  end
end
