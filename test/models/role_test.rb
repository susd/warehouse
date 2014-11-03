# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "Office role" do
    assert users(:office_user).office?
  end
end
