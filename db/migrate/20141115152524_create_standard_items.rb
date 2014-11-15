class CreateStandardItems < ActiveRecord::Migration
  def change
    create_table :standard_items do |t|
      t.string :name
      t.string :chinese_name

      t.timestamps
    end

    add_index :standard_items, :name
    add_index :standard_items, :chinese_name
  end
end
