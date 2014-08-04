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
#

class Stock < ActiveRecord::Base
  has_many :statements

  # ticker should be a string and unique in a market
  validate  :ticker_should_be_a_string
  validates :ticker, presence: true, uniqueness: {scope: :country, message: 'duplicated ticker in the current market'}

  validates :country, presence: true, inclusion: {in: %w(tw us hk)}
  validates :category, presence: true, inclusion: {in: %w(common finance)}
  validates :sub_category, inclusion: {in: %w(bank insurance broker)}, allow_nil: true

  def ticker_should_be_a_string
    unless ticker.is_a?(String)
      errors.add(:ticker, "should be a string")
    end
  end
end
