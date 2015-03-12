# == Schema Information
#
# Table name: products
#
#  id               :integer          not null, primary key
#  item_id          :string
#  description      :string
#  measure          :string
#  cost_cents       :integer          default("0"), not null
#  state            :integer          default("0")
#  created_at       :datetime
#  updated_at       :datetime
#  product_group_id :integer
#

class Product < ActiveRecord::Base
  include AASM
  
  monetize :cost_cents
  
  enum state: {enabled: 0, disabled: 1}
  
  validates_uniqueness_of :item_id
  
  belongs_to :product_group
  has_many :line_items
  has_many :orders, through: :line_items
  
  before_destroy :check_for_line_items
  
  def search_str
    "#{item_id} #{description}".gsub(/\"/,'')
  end
  
  def check_for_line_items
    if line_items.any?
      errors.add(:base, "Orders exist with this product, hide it instead.")
      return false
    else
      return true
    end
  end
  
  def deletable?
    line_items.none?
  end
  
  aasm column: :state, enum: true do
    state :enabled
    state :disabled
    
    event :disable do
      transitions from: :enabled, to: :disabled
    end
    
    event :enable do
      transitions from: :disabled, to: :enabled
    end
  end
  
end
