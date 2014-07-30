class CreateJoinTableStatementStatementItem < ActiveRecord::Migration
  def change
    create_join_table :statements, :statement_items, id: false do |t|
      t.index [:statement_id, :statement_item_id], name: 'index_statement_id_and_statement_item_id'
      t.index [:statement_item_id, :statement_id], name: 'index_statement_item_id_and_statement_id'
    end

    # add_index :statements_statement_items, [:statement_id, :statement_item_id]
    # add_index :statements_statement_items, [:statement_item_id, :statement_id]
  end
end
