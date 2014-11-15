class StandardItem < ActiveRecord::Base
  has_many :items, through :item_standard_item_pairs
end
