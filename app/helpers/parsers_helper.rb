module ParsersHelper
  def render_item(item, px_per_level)
    margin = (item.level - 1) * px_per_level
    color_class = item.has_value ? 'warning' : ''

    content_tag :td, class: "item-name #{color_class}" do
      content_tag(:span, "#{item.name}", style: "margin-left: #{margin}px")
    end
  end

  def render_stock_count(item, category=nil, sub_category=nil)
    stock_count = nil
    if category.blank? && sub_category.blank?
      stock_count = item.stocks.size
    elsif category.present? && sub_category.blank?
      stock_count = item.stocks.where(category: category).size
    elsif category.present? && sub_category.present?
      stock_count = item.stocks.where(category: category, sub_category: sub_category).size
    end

    content_tag(:span, "共 #{stock_count} 檔", class: 'stock-count toggleable-switch')
  end
end
