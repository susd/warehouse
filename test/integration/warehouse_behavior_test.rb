require 'test_helper'

class WarehouseBehaviorTest < ActionDispatch::IntegrationTest
  test "View orders" do
    skip
    with_user(users(:warehouse_user)) do
      visit orders_path
      assert page.has_css?('.order-row')
    end
  end
end