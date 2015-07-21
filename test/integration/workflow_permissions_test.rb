require 'test_helper'

class WorkflowPermissionsTest < ActionDispatch::IntegrationTest

  test "Staff button visibility" do
    with_user(users(:staff_user)) do
      # Draft
      visit order_path(orders(:draft_order))
      assert page.has_link?('Submit For Approval')

      # Submitted
      visit order_path(orders(:submitted_order))
      refute page.has_link?('Approve')
      assert page.has_content?('Submitted, waiting for approval')

      # Approved
      visit order_path(orders(:approved_order))
      refute page.has_link?('Mark Order Fulfilled')
      assert page.has_content?('Approved, waiting for fulfillment')

      # Fulfilled
      visit order_path(orders(:fulfilled_order))
      refute page.has_link?('Archive Order')
      assert page.has_content?('Fulfilled')
    end
  end

  test "Warehouse button visibility" do
    with_user(users(:warehouse_user)) do
      # Draft
      visit order_path(orders(:draft_order))
      refute page.has_link?('Submit For Approval')

      # Submitted
      visit order_path(orders(:submitted_order))
      refute page.has_link?('Approve')
      assert page.has_content?('Submitted, waiting for approval')

      # Approved
      visit order_path(orders(:approved_order))
      assert page.has_link?('Mark Order Fulfilled')

      # Fulfilled
      visit order_path(orders(:fulfilled_order))
      refute page.has_link?('Archive Order')
      assert page.has_content?('Fulfilled')
    end
  end

  test "Quantity button visibility" do
    with_user(users(:quantity_user)) do
      # Draft
      visit order_path(orders(:draft_order))
      refute page.has_link?('Submit For Approval')

      # Submitted
      visit order_path(orders(:submitted_order))
      assert page.has_link?('Approve')

      # Approved
      visit order_path(orders(:approved_order))
      refute page.has_link?('Mark Order Fulfilled')
      assert page.has_content?('Approved, waiting for fulfillment')

      # Fulfilled
      visit order_path(orders(:fulfilled_order))
      refute page.has_link?('Archive Order')
      assert page.has_content?('Fulfilled')
    end
  end

  test "Finance button visibility" do
    with_user(users(:finance_user)) do
      # Draft
      visit order_path(orders(:draft_order))
      refute page.has_link?('Submit For Approval')

      # Submitted
      visit order_path(orders(:submitted_order))
      assert page.has_link?('Approve')

      # Approved
      visit order_path(orders(:approved_order))
      assert page.has_link?('Mark Order Fulfilled')

      # Fulfilled
      visit order_path(orders(:fulfilled_order))
      assert page.has_link?('Archive Order')
    end
  end

  test "Admin button visibility" do
    with_user(users(:admin_user)) do
      # Draft
      visit order_path(orders(:draft_order))
      assert page.has_link?('Submit For Approval')

      # Submitted
      visit order_path(orders(:submitted_order))
      assert page.has_link?('Approve')

      # Approved
      visit order_path(orders(:approved_order))
      assert page.has_link?('Mark Order Fulfilled')

      # Fulfilled
      visit order_path(orders(:fulfilled_order))
      assert page.has_link?('Archive Order')
    end
  end

end
