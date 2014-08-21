class Order < ActiveRecord::Base
  belongs_to :site
  belongs_to :user
  
  has_many :line_items
end
