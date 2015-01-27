require 'test_helper'

class ProductImporterTest < ActiveSupport::TestCase
  
  setup do
    @simple_csv = 'test/fixtures/simple-catalog.csv'
    @full_csv = 'test/fixtures/catalog.csv'
  end
  
  test "Choosing the correct importer" do
    importer = ProductImporter.new(@simple_csv)
    assert_kind_of SimpleProductImporter, importer.strategy
    
    importer = ProductImporter.new(@full_csv)
    assert_kind_of FullProductImporter, importer.strategy
  end
  
end