# == Schema Information
#
# Table name: products
#
#  id               :integer          not null, primary key
#  item_id          :string(255)
#  description      :string(255)
#  measure          :string(255)
#  cost_cents       :integer          default(0), not null
#  state            :integer          default(0)
#  created_at       :datetime
#  updated_at       :datetime
#  product_group_id :integer
#

class Product < ActiveRecord::Base
  monetize :cost_cents
  
  validates_uniqueness_of :item_id
  
  belongs_to :product_group
  has_many :line_items
  has_many :orders, through: :line_items
end
