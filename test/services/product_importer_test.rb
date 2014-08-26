require 'test_helper'

class ProductImporterTest < ActiveSupport::TestCase
  
  setup do
    @importer = ProductImporter.new('test/fixtures/catalog.csv')
  end
  
  test "Reading a CSV file" do
    assert_equal ["SAUGUS UNION SCHOOL DISTRICT", "Page No", "1"], @importer.data.first
  end
  
  test "Finding a page header" do
    assert @importer.page_header? ["SAUGUS UNION SCHOOL DISTRICT", "Page No", "1"]
  end
  
  test "Finding a group header" do
    assert @importer.group_header? ["WH-05", " - ", "CUSTODIAL SUPPLIES"]
    refute @importer.group_header? ["SAUGUS UNION SCHOOL DISTRICT", "Page No", "1"]
    refute @importer.group_header? ["05-00827", "NIGHT LIGHT 13W", "EA", "2.60000"]
  end
  
  test "Finding a column header" do
    assert @importer.column_header? ["Item  ID", "Item Description", "UOM", "Unit Cost"]
  end
  
  test "Finding a pre-existing product" do
    skip
  end
  
  test "Importing a pre-existing product" do
    skip
  end
  
  test "Importing a new product" do
    skip
  end
  
end