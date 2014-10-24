module OrderPermissions
  extend ActiveSupport::Concern
  
  def user_sees_all_orders?
    current_user.roles.any? do |role|
      [:admin, :warehouse, :finance].include? role
    end
  end
  
  def orders_for_user_site(active = true)
    if current_user.site.present?
      orders = current_user.site.orders
      if active
        orders = orders.active.order(created_at: :desc)
      else
        orders = orders.archived.order(created_at: :desc)
      end
    else
      []
    end
  end
  
  def archived_orders_for_user_site
    orders_for_user_site(false)
  end
  
  # This is a stub for future authorization
  def authorize_for_orders
    authorize! { signed_in? } # TODO: change to restrict to site
  end
end