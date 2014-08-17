# == Schema Information
#
# Table name: items
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  level       :integer
#  created_at  :datetime
#  updated_at  :datetime
#  parent_id   :integer
#  has_value   :boolean
#  previous_id :integer
#  next_id     :integer
#  s_type      :string(255)
#

class Item < ActiveRecord::Base
  # self join
  # has_many :child_items, class_name: 'Item', foreign_key: 'parent_item_id'
  # belongs_to :parent_item, class_name: 'Item'

  has_many :item_statement_pairs, dependent: :destroy
  has_many :statements, through: :item_statement_pairs

  has_many :item_stock_pairs, dependent: :destroy
  has_many :stocks, through: :item_stock_pairs


  validates :name, presence: true
  validate  :name_should_be_unique_within_siblings
  validates :has_value, inclusion: {in: [true, false]}
  validates :s_type, presence: true, inclusion: {in: %w(ifrs gaap)}


  # FIXME: We skip this validator at early stage. We have to enable this validator soon
  # validate  :previous_id_and_next_id_should_presence_if_any_sibling_exists


  protected

  def name_should_be_unique_within_siblings
    siblings.each do |sibling|
      if sibling.name == name and sibling.has_value == has_value
        errors.add(:name, 'is already existed within siblins')
      end
    end
  end

  def previous_id_and_next_id_should_presence_if_any_sibling_exists
    if siblings.present?
      if previous_id.nil? and next_id.nil?
        errors.add(:previous_id, 'previous_id should be set if item has sibling(s)')
        errors.add(:next_id, 'next_id should be set if item has sibling(s)')
      end
    end
  end

  # acts_as_tree is to replace self join by gem of closure_tree
  # acts_as_tree should be put at bottom of class
  acts_as_tree dependent: :destroy

end
