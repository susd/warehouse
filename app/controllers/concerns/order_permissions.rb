module OrderPermissions
  extend ActiveSupport::Concern
  
  def user_sees_all_orders?
    current_user.views_all_orders?
  end
  
  # This is a stub for future authorization
  def authorize_for_orders
    authorize! { signed_in? } # TODO: change to restrict to site
  end
end