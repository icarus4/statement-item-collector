# == Schema Information
#
# Table name: item_standard_item_statement_pairs
#
#  id                 :integer          not null, primary key
#  item_id            :integer
#  standard_item_id   :integer
#  statement_id       :integer
#  is_exactly_matched :boolean
#

class ItemStandardItemStatementPair < ActiveRecord::Base
  belongs_to :item
  belongs_to :standard_item
  belongs_to :statement

  validates :standard_item_id, presence: true, uniqueness: { scope: [:item_id, :statement_id, :is_exactly_matched] }
  validates :item_id, presence: true
  validates :statement_id, presence: true
end
