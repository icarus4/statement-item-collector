class StandardItemsController < ApplicationController
  def index
    @s_items = StandardItem.all
  end

  def show
    @si = StandardItem.find(params[:id])
  end
end
