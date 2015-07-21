module ApplicationHelper
  def active_li(options)
    controller = options[:controller] || controller_name
    action = options[:action] || action
    
    active = current_resource?(controller, action)
    # active = false
    # if options[:action].nil?
    #   active = (controller_name == options[:controller])
    # else
    #   active = current_page?(options)
    # end
    html_opts = {}
    html_opts.merge!(class: "active") if active
    content_tag :li, html_opts do
      yield if block_given?
    end
  end
  
  def current_resource?(controller, action)
    (controller_name == controller) && (action_name == action)
  end
  
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end
end
