require 'test_helper'

class OfficeBehaviorTest < ActionDispatch::IntegrationTest
  test "Viewing orders" do
    with_user(users(:office_user)) do
      visit orders_path
      assert page.has_css?('.order-row')
    end
  end
  
  test "Submitting for review" do
    with_user(users(:office_user)) do
      visit order_path(orders(:draft_order))
      click_link 'Send For Review'
    
      assert_equal orders_path, current_path
      assert page.has_content? "Order submitted for review."
    end
  end
end
