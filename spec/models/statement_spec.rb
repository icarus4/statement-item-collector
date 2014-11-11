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
#  s_type     :string(255)
#

require 'spec_helper'

describe Statement do
  pending "add some examples to (or delete) #{__FILE__}"
end
