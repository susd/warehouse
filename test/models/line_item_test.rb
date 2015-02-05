# == Schema Information
#
# Table name: line_items
#
#  id          :integer          not null, primary key
#  product_id  :integer
#  order_id    :integer
#  quantity    :integer          default("1")
#  total_cents :integer          default("0"), not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  setup do
    @product = products(:paper)
  end
  
  test "Invalid if quantity < 0" do
    line_item = LineItem.new(product: @product, quantity: 0)
    refute line_item.valid?
    refute line_item.save
  end
end
