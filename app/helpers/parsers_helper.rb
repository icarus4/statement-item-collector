module ParsersHelper
  def render_item(item, px_per_level)
    margin = (item.level - 1) * px_per_level
    content_tag(:span, item.name, style: "margin-left: #{margin}px")
  end
end
