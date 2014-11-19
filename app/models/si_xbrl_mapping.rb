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

class SiXbrlMapping < ActiveRecord::Base
  belongs_to :standard_item

  validates :xbrl_name, presence: true, uniqueness: { scope: :standard_item_id }
end
