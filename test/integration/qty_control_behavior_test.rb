require 'test_helper'

class QtyControlBehaviorTest < ActionDispatch::IntegrationTest
  
  test "approving an order" do
    with_user(users(:qty_control_user)) do
      visit order_path(orders(:reviewing_order))
      click_link('Qty Control')
      assert_equal order_path(orders(:reviewing_order)), current_path
      assert page.has_content? 'Order approved.'
    end
  end
  
end