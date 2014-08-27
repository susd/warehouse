class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :catalog_file

      t.timestamps
    end
  end
end
