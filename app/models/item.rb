# == Schema Information
#
# Table name: items
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  level      :integer
#  created_at :datetime
#  updated_at :datetime
#  parent_id  :integer
#  has_value  :boolean
#

class Item < ActiveRecord::Base
  # self join
  # has_many :child_items, class_name: 'Item', foreign_key: 'parent_item_id'
  # belongs_to :parent_item, class_name: 'Item'


  has_many :item_statement_pairs
  has_many :statements, through: :item_statement_pairs


  validates :name, presence: true
  validate  :name_should_be_unique_within_siblings
  validates :has_value, inclusion: {in: [true, false]}

  # FIXME: We skip this validator at early stage. We have to enable this validator soon
  # validate  :up_id_and_down_id_should_presence_if_any_sibling_exists


  protected

  def name_should_be_unique_within_siblings
    siblings.each do |sibling|
      if sibling.name == name and sibling.has_value == has_value
        errors.add(:name, 'is already existed within siblins')
      end
    end
  end

  def up_id_and_down_id_should_presence_if_any_sibling_exists
    if siblings.present?
      if up_id.nil? and down_id.nil?
        errors.add(:up_id, 'up_id should be set if item has sibling(s)')
        errors.add(:down_id, 'down_id should be set if item has sibling(s)')
      end
    end
  end

  # acts_as_tree is to replace self join by gem of closure_tree
  # acts_as_tree should be put at bottom of class
  acts_as_tree dependent: :destroy

end
