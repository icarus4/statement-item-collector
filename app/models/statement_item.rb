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

class StatementItem < ActiveRecord::Base
  # self join
  # has_many :child_statement_items, class_name: 'StatementItem', foreign_key: 'parent_statement_item_id'
  # belongs_to :parent_statement_item, class_name: 'StatementItem'

  # replace self join by gem of closure_tree
  acts_as_tree dependent: :destroy

  has_and_belongs_to_many :statements, join_table: :statement_items_statements

end
