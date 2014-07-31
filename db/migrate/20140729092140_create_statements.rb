class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.references :stock, null: false
      t.integer :year, null: false
      t.integer :quarter, null: false

      t.timestamps
    end

    add_index :statements, :stock_id
    add_index :statements, :year
    add_index :statements, :quarter
  end
end
