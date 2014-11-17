class StatementsController < ApplicationController
  def show
    @statement = Statement.find(params[:id])
  end
end
