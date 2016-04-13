angular.module 'app'
  .controller 'CorrelationCtrl', ['$scope', '$http', 'uiGridConstants', ($scope, $http, uiGridConstants)->
    $scope.timeFrames = ['m15', 'm30', 'h1', 'h4', 'd1']
    $scope.isSymCollapsed = true

    _timeFrame = 'm15'
    $scope.timeFrame = (newValue)->
      if arguments.length
        _timeFrame = newValue
        getData()
      _timeFrame

    $scope.isChecked = (symbol)->
      $scope.selectedSymbols.indexOf(symbol) > -1

    $scope.toggleCheck = (symbol)->
      idx = $scope.selectedSymbols.indexOf(symbol)
      if idx == -1
        $scope.selectedSymbols.push symbol
      else
        $scope.selectedSymbols.splice idx, 1
      for i in [ 1...$scope.correlationGrid.columnDefs.length ]
        $scope.correlationGrid.columnDefs[i].visible = $scope.selectedSymbols.indexOf($scope.correlationGrid.columnDefs[i].field) > -1
        $scope.crlGridApi.core.notifyDataChange uiGridConstants.dataChange.COLUMN
      return

    $scope.symbols = []
    $scope.selectedSymbols = []
    $scope.correlationGrid = {
      enableColumnMenus: false
      onRegisterApi: (grisApi)->
        $scope.crlGridApi = grisApi
        return
    }

    getData = ->
      $http.get '/api/get_correlations', {params: {timeFrame: $scope.timeFrame()}}
        .then (response)->
          $scope.symbols = response.data.cols
          $scope.selectedSymbols = response.data.cols.slice 0, 6 unless $scope.selectedSymbols.length
          $scope.correlationGrid.columnDefs = [{ field: 'name', displayName: '', cellClass: 'cell-name' }]
          for col in response.data.cols
            $scope.correlationGrid.columnDefs.push {
              field: col
              displayName: col
              type: 'number'
              cellFilter: 'percentage'
              cellClass: (grid, row, col)->
                val = Math.abs( grid.getCellValue row, col )
                val = Math.floor(val*10) * 10
                'cell-number correlation-' + val
              headerCellClass: 'cell-centred'
              visible: $scope.isChecked(col)
            }
          $scope.correlationGrid.data = response.data.rows
          return
        return

    getData()
    return
  ]
  .filter 'percentage', ['$filter', ($filter)->
    (input)->
      $filter('number')(input * 100, 0) + '%'
  ]
