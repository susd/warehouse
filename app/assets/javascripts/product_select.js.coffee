@App ||= {}

class App.ProductSelect extends App.Element
  init: ->
    @url = @element.data('url')
    @field = @element.find('input#query')
    
  search: ->
    query = @field.val()
    if query.length > 3
      $.ajax {
        url: @url,
        data: {query: query}
        dataType: "script",
        success: @success
        }
    
  success: ->
    App.trigger 'product_select:search'
    new App.ProductSelectOption(option) for option in $('.products-table .product-row')
    
class App.ProductSelectOption extends App.Element    
  init: ->
    @addClass()
    @url = "/products/#{@element.attr('id').split('_')[1]}.js"
    @bindEvents()
  
  addClass: ->
    @element.addClass('js-clickable')
    
  fetch: ->
    $.getScript(@url)
    
  bindEvents: =>
    @element.on 'click', (e) =>
      e.preventDefault()
      @fetch()

$(document).on 'ready page:load', ->
  if $('.product-select').length > 0
    App.pselect = new App.ProductSelect('.product-select')
    
    debouncedQuery = jQuery.debounce 500, false, =>
      App.pselect.search()

    $(document).on 'keyup', App.pselect.field, debouncedQuery