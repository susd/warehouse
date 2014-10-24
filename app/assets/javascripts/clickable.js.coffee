$(document).on 'ready page:load', ->
  $('.clickable tr').on 'click', (e) ->
    # TODO: header row should not be clickable
    Turbolinks.visit($(this).attr('href'))
    
  $('.clickable tr a').on 'click', (e) ->
    e.stopPropagation()
    true
