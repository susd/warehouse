require 'test_helper'

class FullProductImporterTest < ActiveSupport::TestCase
  
  setup do
    @importer = FullProductImporter.new('test/fixtures/catalog.csv')
  end
  
  test "Reading a CSV file" do
    assert_equal ["SAUGUS UNION SCHOOL DISTRICT", "Page No", "1"], @importer.data.first
  end
  
  test "Finding a page header" do
    assert @importer.page_header? ["SAUGUS UNION SCHOOL DISTRICT", "Page No", "1"]
  end
  
  test "Finding a report header" do
    assert @importer.report_header? ["Report ID: LAIN002C", "Inventory Stock Catalog", "Run Date:", "8/23/2014"]
    assert @importer.report_header? ["District :", "64998", "Sorted by Item Id", "Run Time", "8:23:45 AM"]
  end
  
  test "Finding a group header" do
    assert @importer.group_header? ["WH-05", " - ", "CUSTODIAL SUPPLIES"]
    refute @importer.group_header? ["SAUGUS UNION SCHOOL DISTRICT", "Page No", "1"]
    refute @importer.group_header? ["05-00827", "NIGHT LIGHT 13W", "EA", "2.60000"]
  end
  
  test "Finding a column header" do
    assert @importer.column_header? ["Item  ID", "Item Description", "UOM", "Unit Cost"]
  end
  
  test "Finding a header in general" do
    assert @importer.header? ["WH-05", " - ", "CUSTODIAL SUPPLIES"]
    assert @importer.header? ["SAUGUS UNION SCHOOL DISTRICT", "Page No", "1"]
    assert @importer.header? ["Item  ID", "Item Description", "UOM", "Unit Cost"]
    refute @importer.header? ["05-00827", "NIGHT LIGHT 13W", "EA", "2.60000"]
  end
  
  test "Importing a new product group" do
    assert_difference 'ProductGroup.count' do
      @importer.import_group ["WH-05", " - ", "CUSTODIAL SUPPLIES"]
    end
  end
  
  test "Formatting new product group" do
    @importer.import_group ["WH-05", " - ", "CUSTODIAL SUPPLIES"]
    assert_equal "Custodial Supplies", ProductGroup.last.name
  end
  
  test "Importing an existing product group" do
    assert_no_difference 'ProductGroup.count' do
      @importer.import_group ["WH-02", " - ", "OFFICE SUPPLIES"]
    end
  end
  
  test "Finding a pre-existing product" do
    assert @importer.preexisting? ["01-00122", "PAPER WHITE - 12 X 18 STORY BOOK RULED  9\" HEAD", "RM", "16.07000"]
  end
  
  test "Importing a pre-existing product" do
    product = products(:basketball)
    prod_count = Product.count
    assert_equal 464, product.cost_cents
    
    @importer.import_product ["03-00608", "BASKETBALL, OFFICIAL SIZE", "EA", "5.59000"]
    
    assert_equal prod_count, Product.count
    product.reload
    assert_equal 559, product.cost_cents
  end
  
  test "Importing a new product" do
    assert_difference 'Product.count' do
      @importer.import_product ["03-00627", "SOFTBALL, OFFICIAL SIZE-REGULAR SBR", "EA", "2.08000"]
    end
  end
  
  test "Import from file" do
    # assert_difference 'Product.count', 209 do
    #
    # end
    @importer.import!
    assert_equal 212, Product.count
    assert_equal 7, ProductGroup.count
  end
  
end