require 'test_helper'

class SimpleProductImporterTest < ActiveSupport::TestCase
  
  setup do
    @importer = SimpleProductImporter.new('test/fixtures/simple-catalog.csv')
    @row1 = ["01-00122", "PAPER WHITE - 12 X 18 STORY BOOK RULED  9\" HEAD", "RM", "16.07000"]
    @row24 = ["03-00601", "BALL TETHER 12 OZ.", "EA", "7.31000"]
    @row218 = ["07-02005", "DISPOSABLE PARTICULATE RESPIRATOR #8210", "EA", "1.05000"]
  end
  
  test "reading a CSV file" do
    assert_equal @row1, @importer.data.first
  end
  
  test "detecting new product groups" do
    @importer.import_group(@row1)
    assert_equal @importer.current_group, product_groups(:instructional_supplies)
    
    @importer.import_group(@row24)
    assert_equal @importer.current_group, product_groups(:athletic_supplies)
  end
  
  test "Finding a pre-existing product" do
    assert @importer.preexisting? @row1
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
  
  test "Import a row" do
    assert_difference(['Product.count', 'ProductGroup.count'], 1) do
      @importer.import_row @row218
    end
  end
  
  test "Import from file" do
    @importer.import!
    assert_equal 212, Product.count
    assert_equal 7, ProductGroup.count
  end
end