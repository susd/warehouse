module ProductsHelper
  def product_row_tag(product)
    options = {
      data: {
        item_id: product.item_id,
        search: product.search_str,
        cost: product.cost_cents
      },
      class: 'product-row'
    }
    
    content_tag_for(:tr, product, nil, options) do
      yield if block_given?
    end
  end
end
