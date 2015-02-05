module OrderQuerying
  extend ActiveSupport::Concern
  
  def orders_for_user(state = nil)
    relation = Order.all
    
    if state.present?
      relation = scope_orders_by_state(relation, state)
    else
      relation = scope_orders_by_role(relation)
    end
    
    scope_orders_by_site(relation, params[:site_id])
  end
  
  def order_for_user
    orders_for_user.find(params[:id])
  end
  
  def scope_orders_by_state(relation, state)
    relation.where(state: Order.states[state])
  end
  
  def scope_orders_by_role(relation)
    if current_user.admin?
      return relation
    end
    
    if current_user.office?
      states = [0,1,2]
    else
      states = [1,2]
    end
    relation.where(state: states)
  end
  
  def scope_orders_by_site(relation, site_id = nil)
    if site_id.present?
      relation.where(site_id: site_id)
    else
      if current_user.site.nil?
        return relation
      end
      if current_user.views_all_orders?
        relation
      else
        relation.where(site_id: current_user.site.id)
      end
    end
  end
  
end