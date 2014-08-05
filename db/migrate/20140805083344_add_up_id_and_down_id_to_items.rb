class AddUpIdAndDownIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :up_id, :integer, null: true, default: nil
    add_column :items, :down_id, :integer, null: true, default: nil
    add_index :items, :up_id
    add_index :items, :down_id
  end
end
