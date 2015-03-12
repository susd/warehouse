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
  
  def approval_item(role, order)
    approved = order.approvals.where(role: role).any?
    
    li_classes = ['list-group-item']
    li_classes << 'list-group-item-success' if approved
    
    options = {class: li_classes.join(' ')}
    
    icon = approved ? 'glyphicon-ok' : 'glyphicon-remove'
    
    content_tag :li, options do
      content_tag(:span, nil, class: "glyphicon #{icon}") + " #{role.name.titlecase}"
    end
  end
  
  def approval_button(role, order)
    approved = order.approvals.where(role: role).any?
    
    classes = ['btn']
    if approved
      classes << 'btn-success'
    else
      classes << 'btn-default'
    end
    
    icon = approved ? 'glyphicon-ok' : 'glyphicon-time'
    
    options = {
      class: classes.join(' '),
      method: :post
    }
    
    params = {approval: {role_id: role.id}}
    
    if current_user.roles.include? role
      href = order_approvals_path(order, params)
    else
      href = "javascript:;"
    end
    
    link_to href, options do
      content_tag(:span, nil, class: "glyphicon #{icon}") + " #{role.name.titlecase}"
    end
  end
  
end
