class AddSTypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :s_type, :string
    add_index :items, :s_type
  end
end
