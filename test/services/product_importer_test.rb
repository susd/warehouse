require 'test_helper'

class ProductImporterTest < ActiveSupport::TestCase
  
  setup do
    @importer = ProductImporter.new(Rails.root + 'test/fixtures/catalog.csv')
  end
  
  test "Reading a CSV file" do
    assert_equal ["SAUGUS UNION SCHOOL DISTRICT", "Page No", "1"], @importer.data.first
  end
  
end