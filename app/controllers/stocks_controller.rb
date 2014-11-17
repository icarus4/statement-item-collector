class StocksController < ApplicationController
  def show
    @stock = Stock.find(params[:id])
  end
end
