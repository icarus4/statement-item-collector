# == Schema Information
#
# Table name: item_stock_pairs
#
#  id       :integer          not null, primary key
#  item_id  :integer          not null
#  stock_id :integer          not null
#

class ItemStockPair < ActiveRecord::Base
  belongs_to :item, autosave: false, counter_cache: :stocks_count
  belongs_to :stock, autosave: false, counter_cache: :items_count
end
