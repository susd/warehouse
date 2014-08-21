class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :site, index: true
      t.belongs_to :user, index: true
      t.string :state

      t.timestamps
    end
  end
end
