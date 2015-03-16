require 'test_helper'

class StaffBehaviorTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:staff_user)
  end
  
  test "Viewing orders" do
    skip
    with_user(@user) do
      visit orders_path
      assert page.has_css?('.order-row')
    end
  end
  
  test "Submitting for review" do
    skip
    with_user(@user) do
      visit order_path(orders(:draft_order))
      click_link 'Send For Review'
    
      assert_equal orders_path, current_path
      assert page.has_content? "Order submitted for review."
    end
  end
  
  test "Viewing order after submission" do
    skip
    visit order_path(orders(:reviewing_order))
    
    refute page.has_link? 'Send For Review'
  end
end
