class RenameItemStatementsToItemStatementPairs < ActiveRecord::Migration
  def change
    rename_table :item_statements, :item_statement_pairs
  end
end
