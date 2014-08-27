# == Schema Information
#
# Table name: product_groups
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  budget       :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  group_number :integer
#

require 'test_helper'

class ProductGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
