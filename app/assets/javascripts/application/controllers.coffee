angular.module 'app'
  .controller 'CorrelationCtrl', ['$scope', '$http', ($scope, $http)->
    $scope.correlationGrid = {enableColumnMenus: false}
    $http.get '/api/get_correlations'
      .then (response)->
        $scope.correlationGrid.columnDefs = [{ field: 'name', displayName: '' }]
        for col in response.data.cols
          $scope.correlationGrid.columnDefs.push {
            field: col,
            displayName: col,
            type: 'number',
            cellFilter: 'percentage'
            cellClass: 'cell-number'
            headerCellClass: 'cell-centred'
          }
        $scope.correlationGrid.data = response.data.rows
        false
    return
  ]
  .filter 'percentage', ['$filter', ($filter)->
    (input)->
      $filter('number')(input * 100, 0) + '%'
  ]
