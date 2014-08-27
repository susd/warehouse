class AddGroupNumberToProductGroups < ActiveRecord::Migration
  def change
    add_column :product_groups, :group_number, :integer
  end
end
