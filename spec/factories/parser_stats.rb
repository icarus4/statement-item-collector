# == Schema Information
#
# Table name: parser_stats
#
#  id                          :integer          not null, primary key
#  statement_id                :integer
#  gfs_value_count             :integer
#  xbrl_value_count            :integer
#  value_match_count           :integer
#  xbrl_value_discovered_ratio :float
#  accuracy_ratio              :float
#  created_at                  :datetime
#  updated_at                  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :parser_stat do
  end
end
