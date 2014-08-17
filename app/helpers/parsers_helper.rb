module ParsersHelper
  def render_item(item, px_per_level)
    margin = (item.level - 1) * px_per_level
    color_class = item.has_value? ? 'warning' : ''

    content_tag :td, class: "item-name #{color_class}" do
      content_tag(:span, "#{item.name}", style: "margin-left: #{margin}px")
    end
  end
end
