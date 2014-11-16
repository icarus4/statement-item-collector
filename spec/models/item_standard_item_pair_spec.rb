# == Schema Information
#
# Table name: item_standard_item_pairs
#
#  id               :integer          not null, primary key
#  standard_item_id :integer          not null
#  item_id          :integer          not null
#  exact_match      :boolean
#

require 'rails_helper'

RSpec.describe ItemStandardItemPair, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
