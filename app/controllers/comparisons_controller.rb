class ComparisonsController < ApplicationController
  def index
  end

  def search
    @search = params[:stock_id]
  end
end
