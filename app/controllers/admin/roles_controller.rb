class Admin::RolesController < AdminController
  before_filter :set_role, except: [:index, :new, :create]
  after_filter :authorize_for_admin
  
  def index
    @roles = roles_scope
  end
  
  def show
  end
  
  def new
    @role = role_scope.new
  end
  
  def edit
  end
  
  def create
    @role = role_scope.new(role_params)
    if @role.save
      redirect_to admin_roles_path, notice: 'Role created'
    else
      render :new
    end
  end
  
  def update
    if @role.update(role_params)
      redirect_to admin_roles_path, notice: 'Role updated'
    else
      render :edit
    end
  end
  
  private
  
  def roles_scope
    Role.order(:name)
  end
  
  def role_scope
    Role.all
  end
  
  def set_role
    @role = role_scope.find(params[:id])
  end
  
  def role_params
    params.require(:role).permit(:name)
  end
  
end