module ParsersHelper
  def render_item(item, px_per_level)
    margin = (item.level - 1) * px_per_level
    color_class = item.has_value ? 'warning' : ''

    content_tag :td, class: "item-name #{color_class}" do
      concat content_tag(:span, "#{item.name}", style: "margin-left: #{margin}px")
      concat content_tag(:span, " - #{item.s_type}", style: "color: lightgray")
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

  def render_corresponding_statements(item, s_type=nil, category=nil, sub_category=nil)
    if category.blank? && sub_category.blank?
      stocks = item.stocks
    elsif category.present? && sub_category.blank?
      stocks = item.stocks.where(category: category)
    elsif category.present? && sub_category.present?
      stocks = item.stocks.where(category: category, sub_category: sub_category)
    end

    stocks.order(:ticker).find_each do |stock|
      concat _capture_stock(stock, item, s_type)
    end
  end

  def _capture_stock(stock, item, s_type=nil)
    raise 's_type should not be nil' if s_type.nil?
    related_statements = Statement.where(stock_id: stock.id).includes(:item_statement_pairs).where(item_statement_pairs: {item_id: item.id})
    capture do
      content_tag(:li) do
        concat content_tag(:span, "#{stock.ticker} (#{related_statements.size} 次)", class: 'ticker toggleable-switch')
        concat _capture_statements(related_statements.order(:year, :quarter))
      end
    end
  end

  def _capture_statements(statements)
    capture do
      content_tag(:ul, class: 'toggleable', style: 'display: none') do
        statements.order(:year, :quarter).find_each do |st|
          concat content_tag(:li, "#{st.year} Q#{st.quarter}")
        end
      end
    end
  end
end
