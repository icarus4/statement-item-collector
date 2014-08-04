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
  has_and_belongs_to_many :items, join_table: :items_statements
end
