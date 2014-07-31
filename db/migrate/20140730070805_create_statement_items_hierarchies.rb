class CreateStatementItemsHierarchies < ActiveRecord::Migration
  def change
    create_table :statement_item_hierarchies, id: false do |t|
      t.integer  :ancestor_id, :null => false   # ID of the parent/grandparent/great-grandparent/... statement_item
      t.integer  :descendant_id, :null => false # ID of the target statement_item
      t.integer  :generations, :null => false   # Number of generations between the ancestor and the descendant. Parent/child = 1, for example.
    end

    # For "all progeny of…" and leaf selects:
    add_index :statement_item_hierarchies, [:ancestor_id, :descendant_id, :generations], :unique => true, :name => "statement_item_anc_desc_udx"

    # For "all ancestors of…" selects,
    add_index :statement_item_hierarchies, [:descendant_id], :name => "statement_item_desc_idx"
  end
end
