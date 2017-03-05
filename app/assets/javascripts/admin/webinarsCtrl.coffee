angular.module 'admin'
.controller 'WebinarsCtrl', ['$scope', '$http', ($scope, $http)->
  $scope.webinars =[]
  $scope.webinarsGrid = {
    columnDefs: [
      { name: 'E-mail', field: 'email' }
      { name: 'Language', field: 'locale' }
      { name: 'Webinar', field: 'name' }
      {
        name: 'Date'
        field: 'created_at'
        type: 'date'
        cellFilter:'date:"dd-MM-yyyy"'
      }
    ]
    data: 'webinars'
  }

  $http.get '/admin/webinars/index.json'
    .then (resp)->
      $scope.webinars = resp.data
      for w in $scope.webinars
        w.created_at = new Date w.created_at
]
