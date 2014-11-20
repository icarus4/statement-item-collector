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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :value_comparison do
  end
end
