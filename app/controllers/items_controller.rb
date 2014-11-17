class ItemsController < ApplicationController
  def show
    @item = Item.includes(:stocks, :standard_items).find(params[:id])
  end
end
