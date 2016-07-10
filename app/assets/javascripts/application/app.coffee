angular.module 'app', [
  'ngAnimate'
  'ngTouch'
  'ui.grid'
  'ui.grid.pinning'
  'ui.bootstrap'
], ['$locationProvider', ($locationProvider)->
  $locationProvider.html5Mode true
  return
]

# bootstrap app
$(document).on 'ready page:load', ->
  angular.bootstrap document.body, [ 'app' ]
  return

