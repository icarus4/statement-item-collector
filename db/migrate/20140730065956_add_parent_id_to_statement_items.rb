class AddParentIdToStatementItems < ActiveRecord::Migration
  def change
    add_column :statement_items, :parent_id, :integer
    add_index :statement_items, :parent_id
  end
end
