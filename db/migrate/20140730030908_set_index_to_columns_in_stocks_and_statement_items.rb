class SetIndexToColumnsInStocksAndStatementItems < ActiveRecord::Migration
  def change
    add_index :stocks, :ticker

    add_index :statement_items, :name
    add_index :statement_items, :parent_statement_item_id
    add_index :statement_items, :level
  end
end
