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

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
