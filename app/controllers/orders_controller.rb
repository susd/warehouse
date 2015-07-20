class OrdersController < ApplicationController
  include OrderPermissions
  include OrderQuerying
  before_action :set_order, except: [:index, :draft, :submitted, :fulfilled, :approved, :archived, :new, :create]
  before_action :set_site, only:    [:index, :draft, :submitted, :approved, :fulfilled, :archived]
  before_action :set_groups, only:  [:show, :new, :edit]
  after_action  :authorize_for_orders

  # GET /orders
  # GET /orders.json
  def index
    @orders = orders_for_user.order(created_at: :desc)
  end

  def draft
    @orders = orders_for_user(:draft).order(created_at: :desc)
    render template: 'orders/index'
  end

  def submitted
    @orders = orders_for_user(:submitted).order(created_at: :desc)
    render template: 'orders/index'
  end

  def approved
    @orders = orders_for_user(:approved).order(created_at: :desc)
    render template: 'orders/index'
  end

  def fulfilled
    @orders = orders_for_user(:fulfilled).order(created_at: :desc)
    render template: 'orders/index'
  end

  def archived
    @orders = orders_for_user(:archived).order(created_at: :desc)
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
  end

  # GET /orders/1/edit
  def edit
    @order = order_for_user
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new( order_params.merge(user_id: current_user.id, site: current_user.site) )

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
    handle_state_change("submit!", "submitted.")
  end

  def approve
    handle_state_change("approve!", "approved")
  end

  def fulfill
    handle_state_change("fulfill!", "marked fulfilled.")
  end

  def archive
    handle_state_change("archive!", "archived.")
  end

  def cancel
    handle_state_change("cancel!", "cancelled.")
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_groups
    @groups = ProductGroup.order(:group_number).includes(:active_products)
  end

  def set_site
    if params[:site_id]
      @site = Site.by_param(params[:site_id])
    end
  end

  def order_params
    params.require(:order).permit(:site_id, :state, line_items_attributes: [:id, :quantity, :product_id, :_destroy])
  end

  def new_order_for(user)
    Order.new(user: user, site: user.site)
  end

  def handle_state_change(state, msg)
    if @order.send(state)
      redirect_to orders_path, notice: "Order #{msg}."
    else
      redirect_to response.referrer, alert: "Order could not be #{msg}."
    end
  end

end
