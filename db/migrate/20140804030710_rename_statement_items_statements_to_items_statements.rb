class RenameStatementItemsStatementsToItemsStatements < ActiveRecord::Migration
  def change
    rename_table :statement_items_statements, :items_statements
  end
end
