module ApplicationHelper
  def active_li(options)
    active = false
    if options[:action].nil?
      active = (controller_name == options[:controller])
    else
      active = current_page?(options)
    end
    html_opts = {}
    html_opts.merge!(class: "active") if active
    content_tag :li, html_opts do
      yield if block_given?
    end
  end
end
