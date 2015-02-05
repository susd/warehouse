#= require jasmine-fixture
#= require application

dom = {}
v = {}

describe 'OrderForm', ->
  beforeEach ->
    dom.top   = affix('#order-form.order-empty')
    dom.form  = dom.top.affix('form')
    dom.items = dom.form.affix('table#order-items')
    dom.tpl   = dom.top.affix('#line_item-template')
    $(document).trigger 'page:load'
    
    
  it 'wraps the element', ->
    expect(App.order_form.element.is(dom.top)).toBe(true)
    
  it 'finds the form', ->
    expect(App.order_form.form.is(dom.form)).toBe(true)
    
  it 'finds the template', ->
    expect(App.order_form.template.is(dom.tpl)).toBe(true)
    
    
  describe 'form with line_items', ->
    beforeEach ->
      dom.item1 = dom.items.affix('tr.line_item')
      $(document).trigger 'page:load'
      
    it 'finds existing line_items', ->
      expect(App.order_form.items[0].element.is(dom.item1)).toBe(true)
      
    it 'removes the empty class', ->
      expect(App.order_form.element.hasClass('order-empty')).toBe(false)
      
  describe 'form without line_items', ->
    beforeEach ->
      $(document).trigger 'page:load'
      
    it 'does not remove the empty class', ->
      expect(App.order_form.items.length).toEqual(0)
      expect(App.order_form.element.hasClass('order-empty')).toBe(true)