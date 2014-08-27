# == Schema Information
#
# Table name: line_items
#
#  id             :integer          not null, primary key
#  product_id     :integer
#  order_id       :integer
#  quantity       :integer
#  total_cents    :integer          default(0), not null
#  total_currency :string(255)      default("USD"), not null
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
