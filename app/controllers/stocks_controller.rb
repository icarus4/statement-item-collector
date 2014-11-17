class StocksController < ApplicationController
  def index
    @stocks = Stock.all.order(:ticker)
  end

  def show
    @stock = Stock.find(params[:id])
  end
end
