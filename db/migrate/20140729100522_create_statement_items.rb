class CreateStatementItems < ActiveRecord::Migration
  def change
    create_table :statement_items do |t|
      t.string :name, null: false
      t.integer :parent_statement_item_id
      t.integer :level

      t.timestamps
    end
  end
end
