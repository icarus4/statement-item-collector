# == Schema Information
#
# Table name: statement_items
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  level        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  parent_id    :integer
#  statement_id :integer
#

class Item < ActiveRecord::Base
  # self join
  # has_many :child_items, class_name: 'Item', foreign_key: 'parent_item_id'
  # belongs_to :parent_item, class_name: 'Item'

  # replace self join by gem of closure_tree
  acts_as_tree dependent: :destroy

  has_many :item_statement_pairs
  has_many :statements, through: :item_statement_pairs

end
