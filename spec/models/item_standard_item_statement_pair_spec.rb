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

require 'rails_helper'

RSpec.describe ItemStandardItemStatementPair, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
