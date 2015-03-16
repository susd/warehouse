require 'test_helper'

class WorkflowTest < ActionDispatch::IntegrationTest
  
  test "starting a new order" do
    with_user(users(:staff_user)) do
      assert_nothing_raised do
        visit new_order_path
      end
    end
  end
  
  test "Viewing orders" do
    with_user(users(:staff_user)) do
      visit orders_path
      assert page.has_css?('.order-row')
    end
  end
  
  test "Approving order" do
    with_user(users(:principal_user)) do
      visit order_path(orders(:submitted_order))
      
      assert page.has_content?('Principal')
      assert page.has_content?('Quantity')
      
      refute page.has_content?('Send for Review')
      
      click_link('Principal')
      
      assert_equal order_path(orders(:submitted_order)), current_path
      assert page.has_content? 'Order approved.'
    end
    
    with_user(users(:quantity_user)) do
      visit order_path(orders(:submitted_order))
      
      assert page.has_content?('Principal')
      assert page.has_content?('Quantity')
      
      click_link('Quantity')
      
      assert_equal order_path(orders(:submitted_order)), current_path
      assert page.has_content? 'Order approved.'
    end
  end
  
end