class RenameIndexOfItemsStatements < ActiveRecord::Migration
  def change
    rename_index :items_statements, :index_statement_item_id_and_statement_id, :index_item_id_and_statement_id
    rename_index :items_statements, :index_statement_id_and_statement_item_id, :index_statement_id_and_item_id
  end
end
