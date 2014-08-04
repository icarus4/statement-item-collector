class CreateItemStatements < ActiveRecord::Migration
  def change

    drop_table :item_statements

    create_table :item_statements do |t|
      t.belongs_to :item, null: false
      t.belongs_to :statement, null: false
      t.index :item_id
      t.index :statement_id
      t.index [:item_id, :statement_id], unique: true
      t.index [:statement_id, :item_id], unique: true
    end

    # add_index :item_statements, :item_id
    # add_index :item_statements, :statement_id
    # add_index :item_statements, [:item_id, :statement_id], unique: true
    # add_index :item_statements, [:statement_id, :item_id], unique: true

  end
end
