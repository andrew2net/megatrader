angular.module 'app'
.controller 'SpreadCtrl',
['$scope', '$http', '$filter', 'AppService',
($scope, $http, $filter, AppService)->
  $scope.timeFrames = ['m1', 'm5', 'm15', 'm30', 'h1', 'h4', 'd1']
  $scope.timeFrame = 'h1'
  $scope.symbols = []
  $scope.selectedSymbols = []
  
  $scope.isChecked = (symbol)->
    $scope.selectedSymbols.indexOf(symbol) > -1

  $scope.toggleCheck = (symbol)->
    idx = $scope.selectedSymbols.indexOf(symbol)
    if idx == -1
      $scope.selectedSymbols.push symbol
    else
      $scope.selectedSymbols.splice idx, 1

  $scope.spreadChart = ->
    $scope.loading = true
    symbols = {}
    for s in $scope.selectedSymbols
      symbols[s.id] = s.weight

    $http.post '/api/spread', {symbols: symbols, time_frame: $scope.timeFrame}
      .then (resp)->
        if resp.data and resp.data.length
          $scope.chart = AppService.chartTable resp.data
        $scope.loading = false
        return
    return

  setDefault = (sym, w)->
    tool = $filter('filter')($scope.symbols, {name: sym}, true)
    if tool.length
      tool[0].weight = w
      $scope.selectedSymbols.push tool[0]
    return

  $http.get '/api/tools'
    .then (response)->
      $scope.groups = response.data.groups
      $scope.symbols = response.data.tools
      setDefault 'AUDUSD', '1.7'
      setDefault 'EURUSD', '-0.6'
      setDefault 'NZDUSD', '4'
      google.charts.setOnLoadCallback $scope.spreadChart
      return

  unless google.visualization
    google.charts.load 'current', {packages: ['corechart']}

  return
]
