class Import < ActiveRecord::Base
  mount_uploader :catalog_file, FileUploader
end
