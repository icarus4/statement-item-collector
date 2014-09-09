class CreateItemStockPairs < ActiveRecord::Migration
  def change
    create_table :item_stock_pairs do |t|
      t.belongs_to :item, null: false
      t.belongs_to :stock, null: false
      t.index :item_id
      t.index :stock_id
      t.index [:item_id, :stock_id], unique: true
      t.index [:stock_id, :item_id], unique: true
    end
  end
end
