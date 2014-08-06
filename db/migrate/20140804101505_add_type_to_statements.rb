class AddTypeToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :s_type, :string
    add_index :statements, :s_type
  end
end
