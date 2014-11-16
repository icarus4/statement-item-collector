# == Schema Information
#
# Table name: statements
#
#  id          :integer          not null, primary key
#  stock_id    :integer          not null
#  year        :integer          not null
#  quarter     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  s_type      :string(255)
#  end_date    :date
#  items_count :integer          default(0)
#

class Statement < ActiveRecord::Base
  belongs_to :stock

  has_many :item_statement_pairs, dependent: :destroy
  has_many :items, through: :item_statement_pairs

  validates :s_type, presence: true, inclusion: {in: %w(ifrs gaap)}
  validates :year, uniqueness: {scope: [:stock_id, :end_date]}
  validates :end_date, presence: true

  scope :ifrs, -> { where(s_type: 'ifrs')}
  scope :gaap, -> { where(s_type: 'gaap')}

end
