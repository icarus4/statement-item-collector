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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_standard_item_statement_pair do
  end
end
