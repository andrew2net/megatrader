angular.module 'app', [
  'ngAnimate'
  'ngTouch'
  'ui.grid'
  'ui.grid.pinning'
  'ui.bootstrap'
]

$(document).on 'ready page:load', ->
  angular.bootstrap document.body, [ 'app' ]
  return

