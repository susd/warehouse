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
    with_user(users(:quantity_user)) do
      visit order_path(orders(:submitted_order))

      click_link('Approve')

      assert_equal orders_path, current_path
      assert page.has_content? 'Order approved.'
    end
  end

  test "Warehouse list" do
    with_user(users(:warehouse_user)) do
      visit approved_orders_path

      assert page.has_css?('.order-row')
    end
  end

  test "Fulfilling order" do
    with_user(users(:warehouse_user)) do
      visit order_path(orders(:approved_order))
      click_link('Mark Order Fulfilled')

      assert page.has_content? 'Order marked fulfilled.'
    end
  end

  test "Archiving order" do
    with_user(users(:finance_user)) do
      visit order_path(orders(:fulfilled_order))
      click_link('Archive Order')

      assert page.has_content? 'Order archived.'
    end
  end

end
