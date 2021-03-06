# == Schema Information
#
# Table name: stocks
#
#  id           :integer          not null, primary key
#  ticker       :string(255)      not null
#  created_at   :datetime
#  updated_at   :datetime
#  country      :string(255)      default("tw"), not null
#  category     :string(255)
#  sub_category :string(255)
#  items_count  :integer          default(0)
#

class Stock < ActiveRecord::Base
  has_many :statements, dependent: :destroy

  has_many :item_stock_pairs, dependent: :destroy, autosave: false
  has_many :items, through: :item_stock_pairs

  # ticker should be a string and unique in a country
  validate  :ticker_should_be_a_string
  validates :ticker, presence: true, uniqueness: {scope: :country, message: 'duplicated ticker in the current country'}

  validates :country, presence: true, inclusion: {in: %w(tw us hk)}
  validates :category, inclusion: {in: %w(common finance)}, allow_nil: true
  validates :sub_category, inclusion: {in: %w(bank insurance broker)}, allow_nil: true

  def ticker_should_be_a_string
    unless ticker.is_a?(String)
      errors.add(:ticker, "should be a string")
    end
  end

  def self.get_not_parsed_stocks
    all_stocks = TwseWebStatement.financial_stocks
    parsed_stocks = Stock.all.map {|s| s.ticker.to_i}
    all_stocks.delete_if {|x| parsed_stocks.include?(x) }
  end
end
