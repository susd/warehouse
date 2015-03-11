class AddFkToLineItems < ActiveRecord::Migration
  def change
    add_foreign_key :line_items, :products
  end
end
