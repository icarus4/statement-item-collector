class RemoveUnnecessaryIndexes < ActiveRecord::Migration
  def change
    remove_index :item_statement_pairs, name: 'index_item_statement_pairs_on_item_id'
    remove_index :item_statement_pairs, name: 'index_item_statement_pairs_on_statement_id_and_item_id'

    remove_index :item_stock_pairs, name: 'index_item_stock_pairs_on_item_id'
    remove_index :item_stock_pairs, name: 'index_item_stock_pairs_on_stock_id_and_item_id'
  end
end
