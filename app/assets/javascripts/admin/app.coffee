angular.module 'admin', [
  'ngMessages'
  'ngResource'
  'ui.grid'
  'ui.grid.selection'
  'ui.bootstrap'
]

$(document).on 'ready page:load', ->
  angular.bootstrap document.body, ['admin']
  return
