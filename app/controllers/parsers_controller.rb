class ParsersController < ApplicationController

  def index
  end

  def search
    ticker  = params[:ticker]
    year    = params[:year].to_i
    quarter = params[:quarter].to_i

    @s = TwseWebStatement.new(ticker, year, quarter)
    @s.parse
  end

  def ifrs
    @items = Item.where(s_type: 'ifrs').where.not(name: 'root')

    # FIXME: this query sucks, should be improved later
    # @stocks = @items.map{|i|i.statements.map(&:stock).uniq}.uniq.flatten.uniq.sort_by{|stock|stock.ticker}
  end

end
