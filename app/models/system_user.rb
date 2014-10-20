class SystemUser
  include Singleton
  
  SYSTEM_EMAIL = 'warehouse-system@saugususd.org'
  SYSTEM_NAME   = 'System'
  
  def user
    @user ||= load_system_user
  end
  
  private
  
  def load_system_user
    User.find_by(email: SYSTEM_EMAIL) || init_system_user
  end
  
  def init_system_user
    User.create(email: SYSTEM_EMAIL, password: Devise.friendly_token, username: SYSTEM_NAME)
  end
end