class AllOrdersController < ApplicationController
  include OrderPermissions
  after_action :authorize_for_orders
  
  def index
    @orders = Order.active.order(created_at: :desc)
    render template: 'orders/index'
  end
  
  def archived
    @orders = Order.archived.order(created_at: :desc)
    render template: 'orders/index'
  end
  
  private
  
  def authorize_for_orders
    authorize! { current_user.views_all_orders? }
  end
  
end