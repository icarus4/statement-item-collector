class RemoveParentStatementItemIdFromStatementItems < ActiveRecord::Migration
  def change
    remove_column :statement_items, :parent_statement_item_id
  end
end
