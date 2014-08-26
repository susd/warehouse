class Product < ActiveRecord::Base
  monetize :cost_cents
  
  belongs_to :product_group
  has_many :line_items
  has_many :orders, through: :line_items
end
