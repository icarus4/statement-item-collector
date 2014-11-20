# == Schema Information
#
# Table name: value_comparisons
#
#  id               :integer          not null, primary key
#  standard_item_id :integer
#  statement_id     :integer
#  gfs_value        :float
#  xbrl_value       :float
#  result           :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'

RSpec.describe ValueComparison, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
