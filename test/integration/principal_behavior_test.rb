require 'test_helper'

class PrincipalBehaviorTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:principal_user)
  end

  test "View orders" do
    with_user(@user) do
      visit orders_path
      assert page.has_css?('.order-row')
    end
  end

  test "Approving an order" do
    with_user(@user) do
      visit order_path(orders(:reviewing_order))
      click_link('Principal')
      assert_equal order_path(orders(:reviewing_order)), current_path
      assert page.has_content? 'Order approved.'
    end
  end
  
end