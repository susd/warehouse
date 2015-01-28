require 'test_helper'

class WarehouseBehaviorTest < ActionDispatch::IntegrationTest
  test "View orders" do
    with_user(users(:warehouse_user)) do
      visit orders_path
      assert page.has_css?('.order-row', count: 2)
    end
  end
end