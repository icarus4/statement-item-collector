class AddCategoryAndSubcategoryToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :category, :string
    add_column :stocks, :sub_category, :string

    add_index :stocks, :category
    add_index :stocks, :sub_category
  end
end
