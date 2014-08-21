# == Schema Information
#
# Table name: item_stock_pairs
#
#  id       :integer          not null, primary key
#  item_id  :integer          not null
#  stock_id :integer          not null
#

class ItemStockPair < ActiveRecord::Base
  belongs_to :item
  belongs_to :stock
end