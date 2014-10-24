class OrdersController < ApplicationController
  include OrderPermissions
  before_action :set_order, except: [:index, :archived, :new, :edit, :create]
  before_action :set_groups, only: [:show, :new, :edit]
  after_action :authorize_for_orders

  # GET /orders
  # GET /orders.json
  def index
    if params[:site_id].present?
      @site = Site.find params[:site_id]
      @orders = orders_for_user
    else 
      redirect_to site_orders_path(current_user.site)
    end
  end
  
  def archived
    if params[:site_id].present?
      @site = Site.find params[:site_id]
      @orders = @site.orders.archived.order(created_at: :desc)
    else
      @orders = archived_orders_for_user_site
    end
    render template: 'orders/index'
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @comments = @order.comments.order(created_at: :desc)
  end

  # GET /orders/new
  def new
    @order = new_order_for current_user
    redirect_to edit_order_path(@order)
  end

  # GET /orders/1/edit
  def edit
    @order = order_for_user
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new( order_params.merge(user_id: current_user.id) )

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        set_groups
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def submit
    handle_state_change("submit!", "submitted")
  end
  
  def fulfill
    handle_state_change("fulfill!", "marked fulfilled")
  end
  
  def archive
    handle_state_change("archive!", "archived")
  end
  
  def cancel
    handle_state_change("cancel!", "cancelled")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end
  
  def set_groups
    @groups = ProductGroup.includes(:products)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:site_id, :state, line_items_attributes: [:id, :quantity, :product_id, :_destroy])
  end
  
  def orders_for_user
    if current_user.office?
      states = [0,1,2]
    else
      states = [1,2]
    end
    @site.orders.where(state: states).order(created_at: :desc)
  end
  
  def order_for_user
    if user_sees_all_orders?
      @order = Order.find(params[:id])
    else
      if current_user.site.nil?
        redirect_to orders_path, alert: "Oops you can't do that."
      else
        @order = current_user.site.orders.find(params[:id])
      end
    end
  end
  
  def new_order_for(user)
    Order.create(user: user, site: user.site)
  end
  
  def handle_state_change(state, msg)
    if @order.send(state)
      redirect_to orders_path, notice: "Order #{msg}."
    else
      redirect_to response.referrer, alert: "Order could not be #{msg}."
    end
  end
  
end
