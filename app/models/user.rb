# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  provider               :string
#  uid                    :string
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  google_image_url       :string
#  site_id                :integer
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :omniauthable
         
  has_many :orders
  belongs_to :site
  
  has_and_belongs_to_many :roles
  
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
  
  def role_names
    @role_names ||= roles.pluck(:name)
  end
  
  def admin?
    role_names.include? 'admin'
  end
  
  def warehouse?
    role_names.include? 'warehouse'
  end
  
  def finance?
    role_names.include? 'finance'
  end
  
  def staff?
    role_names.include? 'staff'
  end
  
  def approver?
    ['principal', 'quantity'].any? do |role|
      role_names.include? role
    end
  end
  
  def quantity_approver?
    role_names.include? 'quantity'
  end
  
  def views_all_orders?
    role_names.any? do |role|
      %Q{admin warehouse finance}.include? role
    end
  end
  
  def can_edit_orders?
    roles.any?
  end
  
  def manages_products?
    role_names.any? do |role|
      %Q{admin finance}.include? role
    end
  end
end
