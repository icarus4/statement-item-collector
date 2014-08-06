class RenameItemsStatementsToItemStatements < ActiveRecord::Migration
  def change
    rename_table :items_statements, :item_statements
  end
end
