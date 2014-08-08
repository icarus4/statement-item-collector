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

class Statement < ActiveRecord::Base
  belongs_to :stock

  has_many :item_statement_pairs, dependent: :destroy
  has_many :items, through: :item_statement_pairs

  validates :s_type, presence: true, inclusion: {in: %w(ifrs gaap)}
  validates :year, uniqueness: {scope: [:stock_id, :quarter]}
  validates :quarter, uniqueness: {scope: [:stock_id, :year]}
  validates :stock_id, uniqueness: {scope: [:year, :quarter]}
end
