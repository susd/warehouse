class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.integer :code
      t.string :abbr

      t.timestamps
    end
  end
end
