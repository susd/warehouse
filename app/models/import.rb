# == Schema Information
#
# Table name: imports
#
#  id           :integer          not null, primary key
#  catalog_file :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Import < ActiveRecord::Base
  mount_uploader :catalog_file, FileUploader
end
