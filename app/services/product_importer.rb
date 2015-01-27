class ProductImporter
  def self.import(path)
    FullProductImporter.new(path)
  end
end