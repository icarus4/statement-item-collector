class AddCountryToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :country, :string, default: 'tw', null: false
    add_index :stocks, :country
  end
end
