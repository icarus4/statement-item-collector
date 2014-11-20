# == Schema Information
#
# Table name: value_comparisons
#
#  id               :integer          not null, primary key
#  standard_item_id :integer
#  statement_id     :integer
#  gfs_value        :integer
#  xbrl_value       :integer
#  result           :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ValueComparison < ActiveRecord::Base
  belongs_to :standard_item
  belongs_to :statement

  validates :standard_item_id, presence: true, uniqueness: { scope: :statement_id }
  validates :statement_id, presence: true

  before_save :caclulate_value_comparison_result

  # unknown: either gfs_value or xbrl_value is lacked
  # matched: gfs_value == xbrl_value (and both of them are not nil)
  # unmatched: gfs_value != xbrl_value (and both of them are not nil)
  enum result: { unknown: 0, matched: 1, unmatched: 2 }

  def caclulate_value_comparison_result
    if gfs_value && xbrl_value
      if gfs_value == xbrl_value
        self.result = ValueComparison.results[:matched]
      else
        self.result = ValueComparison.results[:unmatched]
      end
    else
      self.result = ValueComparison.results[:unknown]
    end
  end
end
