class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  # skip_before_filter :authenticate_user!
  def all
    user = User.from_omniauth(auth_params)
    if user.persisted?
      flash[:notice] = "You are now signed in. You must be connected to a site and role before you can do anything."
      sign_in_and_redirect(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  def failure
    #handle you logic here..
    #and delegate to super.
    binding.pry
    super
  end
  
  alias_method :google_oauth2, :all
  alias_method :google, :all
  
  protected
  
  def auth_params
    # auth = env["omniauth.auth"]
    # auth.permit({provider: "", uid: "", info: [:name, :email, :first_name, :last_name, :image]})
    ActionController::Parameters.new(request.env["omniauth.auth"]).permit!
  end

end