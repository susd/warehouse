class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.belongs_to :user, index: true
      t.belongs_to :role, index: true

      t.timestamps null: false
    end
    add_foreign_key :approvals, :users
    add_foreign_key :approvals, :roles
  end
end
