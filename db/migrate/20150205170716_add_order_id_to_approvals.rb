class AddOrderIdToApprovals < ActiveRecord::Migration
  def change
    add_reference :approvals, :order, index: true
    add_foreign_key :approvals, :orders
  end
end
