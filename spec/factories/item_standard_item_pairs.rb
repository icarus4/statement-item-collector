# == Schema Information
#
# Table name: item_standard_item_pairs
#
#  id               :integer          not null, primary key
#  standard_item_id :integer          not null
#  item_id          :integer          not null
#  exact_match      :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_standard_item_pair do
  end
end
