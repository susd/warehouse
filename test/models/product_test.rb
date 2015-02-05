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

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
