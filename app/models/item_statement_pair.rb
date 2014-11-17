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
  belongs_to :item, counter_cache: :statements_count
  belongs_to :statement, counter_cache: :items_count
end
