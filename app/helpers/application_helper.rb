module ApplicationHelper
  def active_li(options)
    cls = "active" if current_page?(options)
    content_tag :li, class: cls do
      yield if block_given?
    end
  end
end
