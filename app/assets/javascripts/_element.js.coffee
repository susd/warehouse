class App.Element
  constructor: (elem) ->
    @element = $(elem)
    @init()
    
  init: ->
    true