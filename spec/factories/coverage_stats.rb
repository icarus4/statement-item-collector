# == Schema Information
#
# Table name: coverage_stats
#
#  id                          :integer          not null, primary key
#  statement_id                :integer
#  gfs_value_count             :integer
#  xbrl_value_count            :integer
#  value_match_count           :integer
#  xbrl_value_discovered_ratio :float
#  coverage_ratio              :float
#  created_at                  :datetime
#  updated_at                  :datetime
#  value_unmatch_count         :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coverage_stat do
  end
end
