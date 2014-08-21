json.array!(@products) do |product|
  json.extract! product, :id, :item_id, :description, :measure, :cost
  json.url product_url(product, format: :json)
end
