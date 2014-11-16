class AddCounterCache < ActiveRecord::Migration
  def up
    # items count of Stock
    add_column :stocks, :items_count, :integer, default: 0
    # update for existing records
    Stock.find_each do |stock|
      stock.update_attribute(items_count: stock.items.size)
    end

    # items count of Statement
    add_column :statements, :items_count, :integer, default: 0
    # update for existing records
    Statement.find_each do |statement|
      statement.update_attribute(items_count: statement.items.size)
    end

    # stocks count and statements count of Item
    add_column :items, :stocks_count, :integer, default: 0
    add_column :items, :statements_count, :integer, default: 0
    # update for existing records
    Item.find_each do |item|
      item.update_attribute(stocks_count: item.stocks.size)
      item.update_attribute(statements_count: item.statements.size)
    end
  end

  def down
    remove_column :stocks, :items_count
    remove_column :statements, :items_count
    remove_column :items, :stocks_count
    remove_column :items, :statements_count
  end
end
