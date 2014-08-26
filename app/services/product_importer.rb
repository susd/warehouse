require 'csv'

class ProductsImporter
  attr_reader :data
  
  def initialize(path)
    @data = import_flat CSV.read(path)
  end
  
  def import!
    
  end
  
  private
  
  def import_flat(csv_data)
    csv_data.map{ |a| a.compact }.keep_if{ |a| a.any? }
  end
end