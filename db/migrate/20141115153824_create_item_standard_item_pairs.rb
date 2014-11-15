class CreateItemStandardItemPairs < ActiveRecord::Migration
  def change
    create_table :item_standard_item_pairs do |t|
      t.belongs_to :standard_item, null: false
      t.belongs_to :item, null: false
      t.index [:standard_item_id , :item_id], unique: true
    end
  end
end
