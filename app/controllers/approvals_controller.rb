class ApprovalsController < ApplicationController
  before_action :set_order
  
  def create
    @approval = @order.approvals.new(approval_params)
    
    if @approval.save
      @order.approve! if @order.requirements_met?
      redirect_to @order, notice: 'Order approved.'
    else
      redirect_to @order, alert: "Order could not be approved."
    end
  end
  
  private 
  
  def set_order
    @order = Order.find params[:order_id]
  end
  
  def approval_params
    params.require(:approval).permit(:role_id).merge(user: current_user)
  end
  
end