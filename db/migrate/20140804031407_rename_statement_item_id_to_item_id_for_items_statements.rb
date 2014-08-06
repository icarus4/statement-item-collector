class RenameStatementItemIdToItemIdForItemsStatements < ActiveRecord::Migration
  def change
    rename_column :items_statements, :statement_item_id, :item_id
  end
end
