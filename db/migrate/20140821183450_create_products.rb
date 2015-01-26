class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :item_id
      t.string :description
      t.string :measure
      t.integer :cost_cents, default: 0, null: false
      t.integer :state, default: 0 

      t.timestamps
    end
  end
end
