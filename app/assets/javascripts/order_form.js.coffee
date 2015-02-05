
class App.OrderForm extends App.Element
  init: ->
    @findForm()
    @findTemplate()
    @findLineItems()
    @checkEmpty()
    @calcTotal()
    @bindEvents()
    
  findForm: ->
    @form = @element.find('form')
    
  findTemplate: ->
    @template = @element.find('#line_item-template')
    
  findLineItems: ->
    @items = []
    @items.push new App.LineItem(item) for item in @element.find('#order-items .line_item-fields:not(.hidden)')
    
  checkEmpty: ->
    if @items? && @items.length > 0
      @element.removeClass('order-empty')
    
  calcTotal: ->
    costs = [0]
    costs.push item.total for item in @items
    @total = costs.reduce (x,y) -> x + y
    App.update 'order-total', Math.abs(@total).toFixed(2)
    @total
    
  newItemTemplate: ->
    d = new Date()
    randId = Math.floor(d.getTime() * Math.random())
    tpl = @template.find('.line_item-fields').clone()
    $(field).attr('name', $(field).attr('name').replace('-##-', randId)) for field in tpl.find('input')
    tpl
      
  addProduct: (product) ->
    tpl = @newItemTemplate()
    item = @buildItem(tpl, product)
    @items.push item
    @element.find('table#order-items').append(item.element)
    @element.removeClass('order-empty')
    @calcTotal()
    product.hide()
    App.trigger 'order:item_added'
    
  buildItem: (elem, product) ->
    item = new App.LineItem(elem)
    item.setProductId(product.element.attr('id'))
    item.setDesc(product.desc)
    item.setQty(1)
    item.setMeasure(product.measure)
    item.setCost(product.cost)
    item.calcTotal()
    item
    
  bindEvents: ->
    # @form.on 'submit', (e) =>
    #   e.preventDefault()
    #   console.log @form.serializeArray()
    
    App.on 'order:qty_update order:item_added', ->
      App.order_form.calcTotal()
    
    App.on 'order:item_removed', ->
      App.order_form.checkEmpty()
  
class App.LineItem extends App.Element
  init: ->
    @qtyField = @element.find('.line_item-quantity input')
    @productIdField = @element.find('.line_item-product_id input')
    @productId = @productIdField.val()
    @findQty()
    @cost = parseFloat(@element.data('unit_cost')) || 0
    @calcTotal()
    @remover = @element.find('.line_item-remove_btn')
    @destroy_field = @element.find('[name="_destroy"]')
    @bindEvents()
    
  findQty: ->
    @qty = parseFloat @qtyField.val()
  
  calcTotal: ->
    @total = (@qty * @cost) / 100
    @element.find('.line_item-total').text("$#{@total.toFixed(2)}")
  
  setProductId: (id) ->
    @productId = id
    @productIdField.val(id.split('_')[1])
  
  setDesc: (desc) ->
    @element.find('.line_item-description').html(desc)
    
  setCost: (cost) ->
    @cost = cost
    @element.data('unit_cost', cost)
    
  setQty: (qty) ->
    @qty = parseFloat qty
    @element.find('.line_item-quantity input').val(@qty)
    
  setMeasure: (measure) ->
    @element.find('.line_item-measure').html(measure)
  
  remove: ->
    @element.addClass('hidden')
    @element.find('.line_item-remove input').val(true)
    idx = App.order_form.items.indexOf(@)
    App.order_form.items.splice(idx, 1)
    App.order_form.calcTotal()
    App.trigger 'order:item_removed', @productId
    
  bindEvents: ->
    @remover.on 'click', (e) =>
      e.preventDefault()
      @remove()
    @qtyField.on 'change', (e) =>
      @findQty()
      @calcTotal()
      App.trigger 'order:qty_update'
    
class App.OrderProduct extends App.Element
  init: ->
    @desc = @element.find('.product-desc').text()
    @measure = @element.find('.product-measure').text()
    @cost = parseFloat(@element.data('cost'))
    @adder = @element.find('.product-add a')
    @bindEvents()
    
  hide: ->
    @element.addClass('hidden')
    
  show: ->
    @element.removeClass('hidden')
    
  bindEvents: ->
    @adder.on 'click', =>
      App.order_form.addProduct(@)
      
    App.on 'order:item_removed', (event, args) =>
      if args == @element.attr('id')
        @show()
  
  
$(document).on 'ready page:load', ->
  new App.OrderProduct(product) for product in $('#order-options .product-row')
  
  if $('#order-form form').length > 0
    App.order_form = new App.OrderForm('#order-form')