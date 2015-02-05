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
end
