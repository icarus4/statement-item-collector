class CreateValueComparisons < ActiveRecord::Migration
  def change
    create_table :value_comparisons do |t|
      t.belongs_to :standard_item
      t.belongs_to :statement
      t.integer :gfs_value
      t.integer :xbrl_value
      t.integer :result, default: nil

      t.index :standard_item_id
      t.index :statement_id
      t.index :result

      t.timestamps
    end
  end
end
