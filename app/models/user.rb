class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, 
         :rememberable, :trackable, :validatable, :omniauthable
         
   def self.new_with_session(params,session)
     if session["devise.user_attributes"]
       new(session["devise.user_attributes"], without_protection: true) do |user|
         user.attributes = params
         user.valid?
       end
     else
       super
     end
   end

   def self.from_omniauth(auth)
     pass = Devise.friendly_token
     user = find_or_create_by(auth.slice('provider', 'uid')) do |u|
       u.provider          = auth['provider']
       u.uid               = auth['uid']
       u.email             = auth['info']["email"]
       u.first_name        = auth['info']["first_name"]
       u.last_name         = auth['info']["last_name"]
       u.google_image_url  = auth['info']['image']

       u.password = pass
       u.password_confirmation = pass
     end

     user
   end
   
   def name
     "#{first_name} #{last_name}"
   end
end
