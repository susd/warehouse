class ChangeStateToEnumInOrders < ActiveRecord::Migration
  def change
    # change_column :orders, :state, :integer, default: 0, null: false
    remove_column :orders, :state
    add_column :orders, :state, :integer, default: 0, null: false
  end
end
