class StandardItemsController < ApplicationController
  def show
    @si = StandardItem.find(params[:id])
  end
end
