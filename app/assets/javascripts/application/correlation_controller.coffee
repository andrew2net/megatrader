angular.module 'app'
  .controller 'CorrelationCtrl', ['$scope', '$http', 'uiGridConstants', '$filter'
  ($scope, $http, uiGridConstants, $filter)->
    $scope.timeFrames = ['m1', 'm5', 'm15', 'm30', 'h1', 'h4', 'd1']
    $scope.isSymCollapsed = false

    _timeFrame = 'h1'
    $scope.timeFrame = (newValue)->
      if arguments.length
        _timeFrame = newValue
        getData()
      _timeFrame

    $scope.isChecked = (symbol)->
      $scope.selectedSymbols.indexOf(symbol.name) > -1

    $scope.toggleCheck = (symbol)->
      idx = $scope.selectedSymbols.indexOf(symbol.name)
      if idx == -1
        $scope.selectedSymbols.push symbol.name
      else
        $scope.selectedSymbols.splice idx, 1
      for i in [ 1...$scope.correlationGrid.columnDefs.length ]
        $scope.correlationGrid.columnDefs[i].visible = $scope.selectedSymbols
          .indexOf($scope.correlationGrid.columnDefs[i].displayName) > -1
      $scope.crlGridApi.core.notifyDataChange uiGridConstants.dataChange.COLUMN
      return

    $scope.symbols = []
    $scope.selectedSymbols = []
    $scope.correlationGrid = {
      enableColumnMenus: false
      onRegisterApi: (gridApi)->
        $scope.crlGridApi = gridApi
        return
    }

    getData = ->
      $scope.loading = true
      $http.get '/api/correlations', {params: {timeFrame: $scope.timeFrame()}}
        .then (response)->
          $scope.correlationGrid.data = $scope.symbols.map (r)->
            row = {name: r.name}
            for c in $scope.symbols
              if r.id == c.id
                val = undefined
              else
                val = if response.data[r.id] and response.data[r.id][c.id]
                        response.data[r.id][c.id]
                      else if response.data[c.id]
                        response.data[c.id][r.id]
                      else
                        undefined
              r[c.name] = val
            r
          $scope.loading = false
          $scope.crlGridApi.core.notifyDataChange uiGridConstants.dataChange.COLUMN
          return
      return

    $http.get '/api/tools'
      .then (response)->
        $scope.groups = response.data.groups
        $scope.symbols = response.data.tools
        unless $scope.selectedSymbols.length
          forexGid = response.data.groups[0].id
          forex = $filter('filter')(response.data.tools, {g_id: forexGid}, true)
          $scope.selectedSymbols = forex.slice(0, 6).map (s)-> s.name
        $scope.correlationGrid.columnDefs = [
          {
            field: 'name'
            displayName: ''
            cellClass: 'cell-name'
            minWidth: 100
            pinnedLeft: true
          }
        ]
        for col in response.data.tools
          $scope.correlationGrid.columnDefs.push {
            field: col.name + '.value'
            displayName: col.name
            type: 'number'
            cellTemplate: """
            <div class='ui-grid-cell-contents'>
              <a ng-href="/spread/?TimeFrame={{grid.appScope.timeFrame()}}&{{row.entity['#{col.name}'].symbol_1}}={{row.entity['#{col.name}'].weight_1}}&{{row.entity['#{col.name}'].symbol_2}}={{row.entity['#{col.name}'].weight_2}}">
                <div>
                  {{row.entity['#{col.name}'].value | percentage}}
                </div>
              </a>
            </div>
            """
            cellFilter: 'percentage'
            minWidth: 100
            cellClass: (grid, row, col)->
              val = grid.getCellValue row, col
              return '' if val == undefined
              val = Math.abs( val )
              val = Math.floor(val*10) * 10
              'cell-number correlation-' + val
            headerCellClass: 'cell-centred'
            visible: $scope.isChecked(col)
          }
        getData()
        return

    return
  ]
