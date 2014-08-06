class RenameStatementItemsToItems < ActiveRecord::Migration
  def change
    rename_table :statement_items, :items
  end
end
