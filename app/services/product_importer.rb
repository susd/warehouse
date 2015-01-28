require 'csv'

class ProductImporter
  attr_reader :strategy
  
  def initialize(path)
    determine_strategy_for(path)
  end
  
  def full_catalog?(path)
    data = CSV.read path
    !!data.detect{|row| page_header? row }
  end
  
  def page_header?(row)
    row.include? "Page No"
  end
  
  def import!
    @strategy.import!
  end
  
  private
  
  def determine_strategy_for(path)
    if full_catalog?(path)
      @strategy = FullProductImporter.new(path)
    else
      @strategy = SimpleProductImporter.new(path)
    end
  end
end