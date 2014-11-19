class StandardItemsController < ApplicationController
  def index
    @s_items = StandardItem.all
  end

  def show
    @si = StandardItem.find(params[:id])
    items = @si.items.where(item_standard_item_pairs: {is_exactly_matched: true})
    @exactly_matched_items = items.sort_by {|i| i.stocks.size }.reverse

    items = @si.items.where(item_standard_item_pairs: {is_exactly_matched: false})
    @not_exactly_matched_items = items.sort_by {|i| i.stocks.size }.reverse
  end
end
