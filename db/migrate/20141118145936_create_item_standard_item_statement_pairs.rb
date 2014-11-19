class CreateItemStandardItemStatementPairs < ActiveRecord::Migration
  def change
    create_table :item_standard_item_statement_pairs do |t|
      t.belongs_to :item, null: false
      t.belongs_to :standard_item, null: false
      t.belongs_to :statement, null: false
      t.boolean :is_exactly_matched

      t.index :item_id
      t.index :standard_item_id
      t.index :statement_id
      t.index :is_exactly_matched
      t.index [:item_id, :standard_item_id, :statement_id, :is_exactly_matched], name: 'index_item_standard_item_statement_pairs'
    end
  end
end
