module OrdersHelper
  
  def next_step_link_for(order)
    link_to order.next_step, {controller: 'orders', action: order.next_step, id: order.id}, class: 'btn btn-primary'
  end
  
end
