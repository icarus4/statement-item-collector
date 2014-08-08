class ParsersController < ApplicationController

  def index
  end

  def parse
    ticker  = params[:ticker]
    year    = params[:year].to_i
    quarter = params[:quarter].to_i

    @s = TwseWebStatement.new(ticker, year, quarter)
    @s.parse
  end

  def ifrs
    @root = Item.where(name: 'root', s_type: 'ifrs').first

    # FIXME: this query sucks, should be improved later
    # @stocks = @items.map{|i|i.statements.map(&:stock).uniq}.uniq.flatten.uniq.sort_by{|stock|stock.ticker}
  end

end
