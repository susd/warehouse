# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :integer          default("0"), not null
#

class Order < ActiveRecord::Base
  # enum state: { draft: 0, reviewing: 1, submitted: 2, fulfilled: 3, archived: 4, cancelled: 5 }
  belongs_to :site
  belongs_to :user
  
  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :line_items, allow_destroy: true
  
  has_many :products, through: :line_items
  has_many :comments
  
  has_many :approvals, dependent: :destroy
  
  validates :user_id, presence: true
  
  include OrderWorkflow
  
  def self.active
    where("state < 2")
  end
  
  def add_product(params)
    current_item = line_items.find_by(product_id: params[:product_id])
    if current_item.present?
      current_item.quantity += (params[:quantity].to_i || 1)
    else
      current_item = line_items.build(params)
    end
    current_item
  end
  
  def editable?
    true
  end
  
  def total_cents
    line_items.map {|li| li.total_cents }.sum
  end
  
  def total
    total_cents.to_f / 100
  end
  
end
