class Product < ActiveRecord::Base
  monetize :cost_cents
  
  has_many :line_items
  has_many :orders, through: :line_items
end
