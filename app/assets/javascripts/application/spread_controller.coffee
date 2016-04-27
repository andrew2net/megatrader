angular.module 'app'
  .controller 'SpreadCtrl', ['$scope', '$http', ($scope, $http)->
    $scope.symbols = []
    $http.get '/api/tool_symbols'
      .then (response)->
        $scope.symbols = response.data
        return
  ]
