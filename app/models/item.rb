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

  has_many :item_statement_pairs, dependent: :destroy, autosave: false
  has_many :statements, through: :item_statement_pairs

  has_many :item_stock_pairs, dependent: :destroy, autosave: false
  has_many :stocks, through: :item_stock_pairs


  validates :name, presence: true
  validate  :name_should_be_unique_within_siblings
  validates :has_value, inclusion: {in: [true, false]}
  validates :s_type, presence: true, inclusion: {in: %w(ifrs gaap)}

  scope :first_item, -> {where(previous_id: nil).first}
  scope :last_item, -> {where(next_id: nil).first}

  # FIXME: We skip this validator at early stage. We have to enable this validator soon
  # validate  :previous_id_and_next_id_should_presence_if_any_sibling_exists

  # a brother of an item is the item who has all field are identical with an item, except has_value is opposite
  def brother
    Item.where(name: self.name, level: self.level, parent_id: self.parent_id, s_type: self.s_type, has_value: !self.has_value).first
    # brothers = Item.where(name: self.name, level: self.level, parent_id: self.parent_id, s_type: self.s_type, has_value: !self.has_value)
    # raise 'There should be only one brother' if brother.size > 1
    # return brothers.first
  end

  def next_item
    Item.find_by_id(self.next_id) # return nil if no record found or input is nil
  end

  def previous_item
    Item.find_by_id(self.previous_id) # return nil if no record found or input is nil
  end

  def is_category?(category)
    self.stocks.where(category: category).present?
  end

  def is_not_category?(category)
    !self.is_category?(category)
  end

  def is_sub_category?(sub_category)
    self.stocks.where(sub_category: sub_category).present?
  end

  def is_not_sub_category?(sub_category)
    !self.is_sub_category?(sub_category)
  end

  protected

  def name_should_be_unique_within_siblings
    self.siblings.each do |sibling|
      if sibling.name == self.name and sibling.has_value == self.has_value
        errors.add(:name, 'is already existed within siblins')
      end
    end
  end

  def previous_id_and_next_id_should_presence_if_any_sibling_exists
    if self.siblings.present?
      if self.previous_id.nil? and self.next_id.nil?
        errors.add(:previous_id, 'previous_id should be set if item has sibling(s)')
        errors.add(:next_id, 'next_id should be set if item has sibling(s)')
      end
    end
  end

  # acts_as_tree is to replace self join by gem of closure_tree
  # acts_as_tree should be put at bottom of class
  acts_as_tree dependent: :destroy

end
