require 'test_helper'

class OfficeBehaviorTest < ActionDispatch::IntegrationTest
  test "Viewing orders" do
    with_user(users(:office_user)) do
      visit orders_path
      assert page.has_css?('.order-row', count: 3)
    end
  end
  
  test "Submitting to warehouse" do
    with_user(users(:office_user)) do
      visit order_path(orders(:draft_order))
      click_link 'Send to Warehouse'
    
      assert_equal orders_path, current_path
      assert page.has_content? "Order submitted"
    end
  end
end
