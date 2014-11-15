class ItemStandardItemPair < ActiveRecord::Base
  belongs_to :standard_item
  belongs_to :item
end
