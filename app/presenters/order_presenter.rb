class OrderPresenter < BasePresenter
  presents :order
  
  def workflow_button
    if order.submitted?
      workflow_status_msg
    else
      if order.editable_by? current_user
        tpl.link_to workflow_label, workflow_path, class: css, method: :put
      else
        workflow_waiting_msg
      end
    end
  end
  
  def workflow_path
    case order.state
    when 'draft'
      tpl.submit_order_path(order)
    when 'approved'
      tpl.fulfill_order_path(order)
    when 'fulfilled'
      tpl.archive_order_path(order)
    end
  end
  
  def workflow_label
    case order.state
    when 'draft'
      'Submit For Approval'
    when 'approved'
      'Mark Order Fulfilled'
    when 'fulfilled'
      'Archive Order'
    end
  end
  
  def workflow_status_msg
    case order.state
    when 'draft'
      'Waiting for submission'
    when 'submitted'
      'Submitted, waiting for approval'
    when 'approved'
      'Approved, waiting for fulfillment'
    when 'fulfilled'
      'Fulfilled'
    end
  end
  
  def approval_button
    tpl.link_to approval_button_path, approval_button_options do
      approval_button_icon
    end
  end
  
  def show_approval_button?
    current_user.quantity_approver?
  end
  
  def approved_by?(role)
    order.approvals.where(role: role).any?
  end
  
  def approval_button_path
    params = {approval: {role_id: quantity_role.id}}
    
    if current_user.roles.include? quantity_role
      path = tpl.order_approvals_path(order, params)
    else
      path = "javascript:;"
    end
    
    path
  end
  
  private
  
  def current_user
    tpl.current_user
  end
  
  def quantity_role
    @role ||= Role.find_by(name: 'quantity')
  end
  
  def approval_button_options
    classes = ['btn']
    if approved_by?(quantity_role)
      classes << 'btn-success'
    else
      classes << 'btn-default'
    end
    
    {
      class: classes.join(' '),
      method: :post
    }
  end
  
  def approval_button_icon
    icon = approved_by?(quantity_role) ? 'glyphicon-ok' : 'glyphicon-time'
    tpl.content_tag(:span, nil, id: "approve_for_quantity", class: "glyphicon #{icon}") + " Approve"
  end
  
end