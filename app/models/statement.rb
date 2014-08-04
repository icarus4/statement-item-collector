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

  has_many :item_statement_pairs
  has_many :items, through: :item_statement_pairs
end
