class ItemsController < ApplicationController
  def show
    @item = Item.includes(:stocks).find(params[:id])
  end
end
