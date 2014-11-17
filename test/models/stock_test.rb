# == Schema Information
#
# Table name: stocks
#
#  id           :integer          not null, primary key
#  ticker       :string(255)      not null
#  created_at   :datetime
#  updated_at   :datetime
#  country      :string(255)      default("tw"), not null
#  category     :string(255)
#  sub_category :string(255)
#  items_count  :integer          default(0)
#

require 'test_helper'

class StockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
