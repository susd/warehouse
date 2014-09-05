class AdminController < ApplicationController
  after_filter :authorize_for_admin
  
  private 
  
  def authorize_for_admin
    authorize! { current_user && current_user.admin? }
  end
end