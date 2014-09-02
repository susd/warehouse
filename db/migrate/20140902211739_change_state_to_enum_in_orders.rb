class ChangeStateToEnumInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :state, :integer, default: 0, null: false
  end
end
