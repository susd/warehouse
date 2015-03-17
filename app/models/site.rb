# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :integer
#  abbr       :string
#  created_at :datetime
#  updated_at :datetime
#

class Site < ActiveRecord::Base
  has_many :orders
  has_many :users
  
  def self.by_param(param)
    if param.to_i > 0
      find(param)
    else
      find_by(abbr: param)
    end
  end
end
