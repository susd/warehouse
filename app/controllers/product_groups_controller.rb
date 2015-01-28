class ProductGroupsController < ApplicationController
  before_action :load_product_group, except: [:index, :new, :create]
  
  def index
    @product_groups = ProductGroup.order(:group_number)
  end
  
  def show
  end
  
  def new
    @product_group = ProductGroup.new
  end
  
  def create
    @product_group = ProductGroup.new(product_group_params)
    if @product_group.save
      redirect_to product_groups_path, notice: 'Product group added.'
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @product_group.update(product_group_params)
      redirect_to product_groups_path, notice: 'Product group updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @product_group.destroy
    redirect_to product_groups_path, notice: 'Product group removed.'
  end
  
  private
  
    def load_product_group
      @product_group = ProductGroup.find params[:id]
    end
  
    def product_group_params
      params.require(:product_group).permit(:name, :budget, :group_number)
    end
  
end