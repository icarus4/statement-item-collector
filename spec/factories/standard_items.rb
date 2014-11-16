# == Schema Information
#
# Table name: standard_items
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  chinese_name :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :standard_item do
  end
end
