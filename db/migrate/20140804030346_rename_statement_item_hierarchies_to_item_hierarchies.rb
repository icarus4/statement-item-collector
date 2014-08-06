class RenameStatementItemHierarchiesToItemHierarchies < ActiveRecord::Migration
  def change
    rename_table :statement_item_hierarchies, :item_hierarchies
  end
end
