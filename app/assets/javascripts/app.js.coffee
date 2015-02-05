->
  'use strict'

window.App = {
  debug: true
  
  on: (eventName, callback) ->
    jQuery(window).on("app:#{eventName}", callback)
    
  off: (eventName, callback) ->
    jQuery(window).off("app:#{eventName}", callback)
    
  one: (eventName, callback) ->
    jQuery(window).one("app:#{eventName}", callback)
    
  trigger: (eventName, options) ->
    jQuery(window).trigger("app:#{eventName}", options)
    if App.debug
      console.log("app:#{eventName}[#{options}]")
      # console.log(options)
      
  update: (subject, new_value) ->
    jQuery("[data-bind=#{subject}]").each ->
      $bound = jQuery( this )
      if $bound.is "input, textarea, select"
        $bound.val( new_value )
      else
        $bound.html( new_value )
    if App.debug
      console.log("update:#{subject}")
}