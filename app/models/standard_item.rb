# == Schema Information
#
# Table name: standard_items
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  chinese_name :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class StandardItem < ActiveRecord::Base
  has_many :item_standard_item_pairs
  has_many :items, through: :item_standard_item_pairs
  has_many :stocks, through: :items
end
