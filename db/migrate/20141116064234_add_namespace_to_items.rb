class AddNamespaceToItems < ActiveRecord::Migration
  def change
    add_column :items, :namespace, :string
  end
end
