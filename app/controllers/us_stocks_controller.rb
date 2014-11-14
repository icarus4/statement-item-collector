class UsStocksController < ApplicationController
  def index
    g = GoogleFinanceParser.new 'fb'
    g.fetch

    @is = g.is_data
    @bs = g.bs_data
    @cf = g.cf_data

    # raise ''
  end
end
