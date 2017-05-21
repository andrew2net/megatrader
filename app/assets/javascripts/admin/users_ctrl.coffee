angular.module 'admin'
.controller 'UsersCtrl', ['$scope', '$http', ($scope, $http)->
  $scope.users = []
  $scope.usersGrid = {
    multiSelect: false
    noUnselect: true
    enableRowSelection: true
    enableRowHeaderSelection: false
    columnDefs: [
      { name: 'E-mail', field: 'email' }
      { name: 'Language', field: 'locale' }
      { name: 'Send news', field: 'send_news', type: 'boolean' }
    ]
    data: 'users'
  }
  $http.get '/admin/users/index.json'
    .then (resp)-> $scope.users = resp.data
]
