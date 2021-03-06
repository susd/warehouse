require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:draft_order)
    @user = users(:staff_user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end
  
  test "get index for Office Manager" do
    get :index
  end

  test "should get new" do
    get :new
    assert_response :success
    # assert_redirected_to edit_order_path(assigns(:order))
  end

  # test "should create order" do
  #   assert_difference('Order.count') do
  #     post :create, order: { site_id: @order.site_id, state: @order.state, user_id: @order.user_id }
  #   end
  #
  #   assert_redirected_to order_path(assigns(:order))
  # end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { site_id: @order.site_id, state: @order.state, user_id: @order.user_id }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
end
