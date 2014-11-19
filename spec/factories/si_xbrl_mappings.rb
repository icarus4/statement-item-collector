# == Schema Information
#
# Table name: si_xbrl_mappings
#
#  id               :integer          not null, primary key
#  standard_item_id :integer
#  xbrl_name        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :si_xbrl_mapping do
  end
end
