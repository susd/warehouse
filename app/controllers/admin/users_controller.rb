class Admin::UsersController < ApplicationController
  before_action :set_user, except: :index
  before_action :set_roles_and_sites, except: :index
  
  def index
    @users = User.all
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'User updated'
    else
      render action: :edit
    end
  end
  
  private
  
  def set_user
    @user = User.find params[:id]
  end
  
  def set_roles_and_sites
    @roles = Role.all.map{|r| [r.name, r.id]}
    @sites = Site.all.map{|s| [s.name, s.id]}
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :role_ids, :site_id)
  end
end
