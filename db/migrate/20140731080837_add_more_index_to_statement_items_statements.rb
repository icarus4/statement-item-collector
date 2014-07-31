class AddMoreIndexToStatementItemsStatements < ActiveRecord::Migration
  def change
    add_index :statement_items_statements, :statement_id
    add_index :statement_items_statements, :statement_item_id
  end
end
