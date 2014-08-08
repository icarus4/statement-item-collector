module ParsersHelper
  def render_item(item, px_per_level)
    margin = (item.level - 1) * px_per_level
    content_tag(:span, "#{item.name} <span style='color: lightgray'>（#{item.parent.name}）</span>".html_safe, style: "margin-left: #{margin}px")
  end
end
