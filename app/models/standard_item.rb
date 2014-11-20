# == Schema Information
#
# Table name: standard_items
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  chinese_name :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class StandardItem < ActiveRecord::Base
  has_many :item_standard_item_pairs
  has_many :items, through: :item_standard_item_pairs

  has_many :stocks, through: :items

  has_many :item_standard_item_statement_pairs

  has_many :xbrl_names, foreign_key: 'standard_item_id', class_name: 'SiXbrlMapping'

  has_many :value_comparisons
end
