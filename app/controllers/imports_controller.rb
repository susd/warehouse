class ImportsController < ApplicationController
  def new
    @import = Import.new
  end
  
  def create
    @import = Import.new import_params
    importer = ProductImporter.new(@import.catalog_file.path)
    
  end
  
  private
  
  def import_params
    params.require(:import).permit(:catalog_file)
  end
end