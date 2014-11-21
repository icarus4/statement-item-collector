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

class ValueComparison < ActiveRecord::Base
  belongs_to :standard_item
  belongs_to :statement

  validates :standard_item_id, presence: true, uniqueness: { scope: :statement_id }
  validates :statement_id, presence: true

  # unknown: either gfs_value or xbrl_value is lacked
  # matched: gfs_value == xbrl_value (and both of them are not nil)
  # unmatched: gfs_value != xbrl_value (and both of them are not nil)
  enum result: { unknown: 0, matched: 1, unmatched: 2 }

  def caclulate_value_comparison_result
    return self.unknown! if gfs_value.nil? || xbrl_value.nil?
    return self.matched! if gfs_value == xbrl_value

    diff = gfs_value - xbrl_value
    if gfs_value != 0
      # diff ratio less than 0.005 and both are positive or are negative values
      diff_ratio = diff.abs / gfs_value.abs
      if diff_ratio < 0.005 && ((gfs_value >= 0 && xbrl_value >= 0) || (gfs_value < 0 && xbrl_value < 0))
        self.matched!
      else
        self.unmatched!
      end
    end
  end
end
