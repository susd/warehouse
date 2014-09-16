class AdminController < ApplicationController
  after_filter :authorize_for_admin
  after_filter :validate_authorization_checked
  
  private 
  
  def authorize_for_admin
    authorize! { current_user && current_user.admin? }
  end
end