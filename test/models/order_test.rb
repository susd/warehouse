# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  site_id    :integer
#  user_id    :integer
#  state      :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
