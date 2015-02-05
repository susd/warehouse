#= require jasmine-fixture
#= require application

dom = {}
v = {}

describe 'ProductSelect', ->
  beforeEach ->
    dom.sel = affix('.product-select[data-url="/products/search"]')
    dom.qdv = dom.sel.affix('.product-select-query')
    dom.qry = dom.sel.affix('input#query[name="query"]')
    $(document).trigger('page:load')
    
  describe 'Initialization', ->
    it 'wraps the element', ->
      expect(App.pselect.element.is(dom.sel)).toBe(true)
      
    it 'finds the query url', ->
      expect(App.pselect.url).toEqual('/products/search')
      
    it 'finds the query field', ->
      expect(App.pselect.field.is(dom.qry)).toBe true
      
  describe 'Debounced query', ->
    beforeEach ->
      spyOn(App.pselect, 'search')
      jasmine.clock().install()
      
    it 'debounces key events', ->
      dom.qry.val('loremipsum')
      expect(App.pselect.field.val()).toEqual('loremipsum')
      
      App.pselect.field.trigger 'keyup'
      App.pselect.field.trigger 'keyup'

      jasmine.clock().tick(1)
      expect(App.pselect.search).not.toHaveBeenCalled()
      jasmine.clock().tick(600)
      expect(App.pselect.search).toHaveBeenCalled()