# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  user_id    :integer
#  state      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Order < ActiveRecord::Base
  # enum state: { draft: 0, pending: 1, fulfilled: 2, archived: 3, deleted: 4 }
  belongs_to :site
  belongs_to :user
  
  has_many :line_items
  has_many :products, through: :line_items
  
  validates :user_id, presence: true
  
  include OrderWorkflow
  
  def add_product(product_id)
    current_item = line_items.find_by(product_id: product_id)
    if current_item.present?
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product_id)
    end
    current_item
  end
  
end
