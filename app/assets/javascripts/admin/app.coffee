angular.module 'admin', []

$(document).on 'ready page:load', ->
  angular.bootstrap document.body, ['admin']
