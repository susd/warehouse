class FixSiteInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :site_id_id, :site_id
  end
end
