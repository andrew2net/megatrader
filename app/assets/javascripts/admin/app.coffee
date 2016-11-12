angular.module 'admin', [
  'ngResource'
  'ui.grid'
  'ui.grid.selection'
]

$(document).on 'ready page:load', ->
  angular.bootstrap document.body, ['admin']
  return
