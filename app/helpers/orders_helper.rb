module OrdersHelper
  
  def next_step_link_for(order)
    link_to order.next_step.name, {controller: 'orders', action: order.next_step.name, id: order.id}, {class: 'btn btn-primary', method: :put}
  end
  
end
