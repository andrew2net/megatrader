angular.module 'app', ['ui.grid']

$(document).on 'ready page:load', ->
  angular.bootstrap document.body, [ 'app' ]
  return

