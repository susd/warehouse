require 'csv'

class SimpleProductImporter
  attr_reader :data
  attr_reader :current_group
  
  def initialize(path)
    @data = read_without_blank_rows(path)
  end
  
  def preexisting?(row)
    Product.exists?(item_id: row[0])
  end
  
  def import_group(row)
    group = ProductGroup.find_or_create_by( group_number: parse_group_number(row[0]) )
    @current_group = group
  end
  
  def import_product(row)
    product = Product.find_or_initialize_by(item_id: row[0])
    attrs = {description: row[1], measure: row[2], cost_cents: parse_cost(row[3])}
    attrs.merge!(product_group: @current_group) if @current_group.present?
    product.update(attrs)
  end
  
  def import_row(row)
    import_group(row)
    import_product(row)
  end
  
  def import!
    @data.each do |row|
      import_row row
    end
  end
  
  private
  
  def read_without_blank_rows(path)
    data = CSV.read(path)
    data.map{ |a| a.compact }.keep_if{ |a| a.any? }
  end
  
  def parse_group_number(str)
    str.scan(/\d+/)[0].to_i
  end
  
  def parse_cost(str)
    (str.to_f * 100).to_i
  end
end