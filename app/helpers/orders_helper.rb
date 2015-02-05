module OrdersHelper
  
  def next_step_link_for(order)
    link_to order.next_step.name, {controller: 'orders', action: order.next_step.name, id: order.id}, {class: 'btn btn-primary', method: :put}
  end
  
  def order_section_tag(order)
    options = {
      id: 'order-form',
      class: order.line_items.any? ? '' : 'order-empty'
    }
    content_tag :section, options do
      yield if block_given?
    end
  end
  
end
