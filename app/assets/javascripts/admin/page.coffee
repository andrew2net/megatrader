# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(() ->
  $('#pageTab a').click((e) ->
    e.preventDefault()
    $(this).tab('show')
    return false
  )
  return false
)

#$('#en-content a').click((e) ->
#  e.preventDefault()
#  $(this).tab('show')
#  return false
#)
