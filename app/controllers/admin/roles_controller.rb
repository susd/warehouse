class Admin::RolesController < AdminController
  after_filter :authorize_for_admin
  
  def index
    @roles = roles_scope
  end
  
  private
  
  def roles_scope
    Role.all
  end
  
end