$(document).on 'ready page:load', ->
  $('.clickable tr').on 'click', (e) ->
    console.log $(this).attr('href')
    Turbolinks.visit($(this).attr('href'))
    
  $('.clickable tr a').on 'click', (e) ->
    e.stopPropagation()
    true
