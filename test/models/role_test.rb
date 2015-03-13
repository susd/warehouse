# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "Staff role" do
    assert users(:staff_user).staff?
  end
end
