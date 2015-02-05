class LineItemsController < ApplicationController
  before_action :set_order
  
  def create
    @line_item = @order.add_product(line_item_params)
    if @line_item.save
      redirect_to edit_order_path(@order)
    end
  end
  
  private
  
  def set_order
    @order = Order.find(params[:order_id]) || Order.new(user: current_user)
  end
  
  def line_item_params
    params.require(:line_item).permit(:product_id, :quantity)
  end
end