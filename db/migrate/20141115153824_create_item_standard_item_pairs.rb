class CreateItemStandardItemPairs < ActiveRecord::Migration
  def change
    create_table :item_standard_item_pairs do |t|
      t.belongs_to :standard_item, null: false
      t.belongs_to :item, null: false
      t.boolean :exact_match
      t.index [:standard_item_id , :item_id, :exact_match], name: 'index_item_standard_item_pairs'
    end
  end
end
