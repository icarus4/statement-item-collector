# == Schema Information
#
# Table name: si_xbrl_mappings
#
#  id               :integer          not null, primary key
#  standard_item_id :integer
#  xbrl_name        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'

RSpec.describe SiXbrlMapping, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
