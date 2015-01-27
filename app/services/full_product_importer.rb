require 'csv'

class FullProductImporter
  attr_reader :data
  
  def initialize(path)
    @data = flatten CSV.read(path)
  end
  
  def page_header?(row)
    row.include? "Page No"
  end
  
  def report_header?(row)
    row.include?("Run Date:") || row.include?("Run Time")
  end
  
  def group_header?(row)
    !!row.detect{|c| c =~ /WH-\d+/ }
  end
  
  def column_header?(row)
    row.include? "Item  ID"
  end
  
  def header?(row)
    page_header?(row) || report_header?(row) || group_header?(row) || column_header?(row)
  end
  
  def preexisting?(row)
    if header? row
      return false
    else
      Product.exists?(item_id: row[0])
    end
  end
  
  def import!
    @data.each do |row|
      if header? row
        import_header row
      else
        import_product row
      end
    end
  end
  
  def import_product(row)
    product = Product.find_or_initialize_by(item_id: row[0])
    attrs = {description: row[1], measure: row[2], cost_cents: parse_cost(row[3])}
    attrs.merge!(product_group: @current_group) if @current_group.present?
    product.update(attrs)
  end
  
  def import_header(row)
    import_group(row) if group_header?(row)
  end
  
  # ["WH-02", " - ", "OFFICE SUPPLIES"]
  def import_group(row)
    group = ProductGroup.find_or_initialize_by(group_number: parse_group_number(row[0]))
    group.update(name: row[2].titlecase)
    @current_group = group
  end
  
  private
  
  def flatten(data)
    data.map{ |a| a.compact }.keep_if{ |a| a.any? }
  end
  
  def parse_cost(str)
    (str.to_f * 100).to_i
  end
  
  def parse_group_number(str)
    str.scan(/\d+/)[0].to_i
  end
end