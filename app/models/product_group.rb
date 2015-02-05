# == Schema Information
#
# Table name: product_groups
#
#  id           :integer          not null, primary key
#  name         :string
#  budget       :string
#  created_at   :datetime
#  updated_at   :datetime
#  group_number :integer
#

class ProductGroup < ActiveRecord::Base
  has_many :products
end
