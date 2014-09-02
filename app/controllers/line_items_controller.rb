class LineItemsController < ApplicationController
  
  def create
    order = Order.find(params[:order_id])
    @line_item = order.add_product(line_item_params)
  end
  
  private
  
  def line_item_params
    params.require(:line_item).permit(:product_id, :quantity)
  end
end