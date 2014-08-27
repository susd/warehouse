class FixGroupIdInProducts < ActiveRecord::Migration
  def change
    rename_column :products, :group_id, :product_group_id
  end
end
