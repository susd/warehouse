class AddSiteToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :site_id, index: true
  end
end
