class AddGroupToProduct < ActiveRecord::Migration
  def change
    add_column  :products, :group_id, :integer
    add_index   :products, :group_id
  end
end
