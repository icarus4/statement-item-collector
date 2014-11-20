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
#

class CoverageStat < ActiveRecord::Base
  belongs_to :statement

  validates :statement_id, presence: true
  validates :gfs_value_count,             numericality: { greater_than_or_equal_to: 0 }
  validates :xbrl_value_count,            numericality: { greater_than_or_equal_to: 0 }
  validates :value_match_count,           numericality: { greater_than_or_equal_to: 0 }
  validates :xbrl_value_discovered_ratio, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
  validates :coverage_ratio,              numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1}
end
