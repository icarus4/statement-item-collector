# == Schema Information
#
# Table name: item_statement_pairs
#
#  id           :integer          not null, primary key
#  item_id      :integer          not null
#  statement_id :integer          not null
#

# Join model for Item and Statement
class ItemStatementPair < ActiveRecord::Base
  belongs_to :item
  belongs_to :statement
end
