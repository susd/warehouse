class CommentsController < ApplicationController
  before_action :set_order
  
  def create
    @comment = @order.comments.new(comment_params)
    
    if @comment.save
      redirect_to @order, notice: 'Comment added.'
    else
      redirect_to @order, alert: "Couldn't save comment."
    end
  end
  
  private 
  
  def set_order
    @order = Order.find params[:order_id]
  end
  
  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end