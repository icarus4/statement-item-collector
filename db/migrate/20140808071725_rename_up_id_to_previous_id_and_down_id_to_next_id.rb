class RenameUpIdToPreviousIdAndDownIdToNextId < ActiveRecord::Migration
  def change
    rename_column :items, :up_id, :previous_id
    rename_column :items, :down_id, :next_id
  end
end
