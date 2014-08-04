class RenameIndexOfItemHierarchies < ActiveRecord::Migration
  def change
    rename_index :item_hierarchies, :statement_item_desc_idx, :item_desc_idx
    rename_index :item_hierarchies, :statement_item_anc_desc_udx, :item_anc_desc_udx
  end
end
