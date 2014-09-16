module AuthorizationSystem
  NotAuthorized = Class.new(StandardError)
  AuthorizationNotChecked = Class.new(StandardError)
  
  protected
  
  def authorize!
    @authorization_checked = true
    raise NotAuthorized unless yield
  end
  
  def validate_authorization_checked
    return if @authorization_checked
    raise AuthorizationNotChecked
  end
end

# class ApplicationController < ActionController::Base
#   include AuthorizationSystem
#   after_filter :validate_authorization_checked
# end

# class MessagesController < ApplicationController
#   # ...
#   def show
#     @message = Message.find(params[:id])
#     authorize! { current_user.can_view? @message }
#   end
# end