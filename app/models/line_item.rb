# == Schema Information
#
# Table name: line_items
#
#  id             :integer          not null, primary key
#  product_id     :integer
#  order_id       :integer
#  quantity       :integer          default(1)
#  total_cents    :integer          default(0), not null
#  total_currency :string(255)      default("USD"), not null
#  created_at     :datetime
#  updated_at     :datetime
#

class LineItem < ActiveRecord::Base
  monetize :total_cents
  
  belongs_to :product
  belongs_to :order
  
  before_save :set_total
  
  validates_numericality_of :quantity, greater_than: 0
  validates :product_id, presence: true
  
  def set_total
    self.total_cents = (quantity * self.product.cost_cents)
  end
  
  def description
    product.description
  end
  
  def measure
    product.measure
  end
end
