# == Schema Information
#
# Table name: item_standard_item_pairs
#
#  id                 :integer          not null, primary key
#  standard_item_id   :integer          not null
#  item_id            :integer          not null
#  is_exactly_matched :boolean
#

class ItemStandardItemPair < ActiveRecord::Base
  belongs_to :standard_item
  belongs_to :item

  validates :standard_item_id, presence: true, uniqueness: { scope: [:item_id, :is_exactly_matched] }
  validates :item_id, presence: true, uniqueness: { scope: [:standard_item_id, :is_exactly_matched] }
end
