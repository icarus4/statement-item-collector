# == Schema Information
#
# Table name: stocks
#
#  id         :integer          not null, primary key
#  ticker     :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  country    :string(255)      default("tw"), not null
#

class Stock < ActiveRecord::Base
  has_many :statements
  # has_many :items, through: :statements
end
