require 'csv'

class ProductImporter
  attr_reader :data
  
  def initialize(path)
    @data = import_flat CSV.read(path)
  end
  
  def import!
    
  end
  
  def page_header?(row)
    row.include? "Page No"
  end
  
  def group_header?(row)
    !!row.detect{|c| c =~ /WH-\d+/ }
  end
  
  def column_header?(row)
    row.include? "Item  ID"
  end
  
  private
  
  def import_flat(data)
    data.map{ |a| a.compact }.keep_if{ |a| a.any? }
  end
end