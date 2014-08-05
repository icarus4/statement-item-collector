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


  protected

  def name_should_be_unique_within_siblings
    self.siblings.each do |sibling|
      if sibling.name == self.name and sibling.has_value == self.has_value
        errors.add(:name, 'is already existed within siblins')
      end
    end
  end

  # replace self join by gem of closure_tree
  # acts_as_tree should be put at bottom of class
  acts_as_tree dependent: :destroy

end
