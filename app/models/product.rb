class Product < ActiveRecord::Base
  monetize :cost_cents
end
