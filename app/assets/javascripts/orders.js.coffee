# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  if $('.line_item-fields').length > 0
    $('.line_item-remove').on 'click', (e) ->
      e.preventDefault()
      $(this).prev().val('true')
      $(this).parents('.line_item-fields').hide()