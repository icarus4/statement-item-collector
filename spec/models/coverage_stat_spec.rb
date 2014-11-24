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

require 'rails_helper'

RSpec.describe CoverageStat, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
