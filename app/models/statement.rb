# == Schema Information
#
# Table name: statements
#
#  id         :integer          not null, primary key
#  stock_id   :integer          not null
#  year       :integer          not null
#  quarter    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Statement < ActiveRecord::Base
  belongs_to :stock
  has_many :statement_items
end
