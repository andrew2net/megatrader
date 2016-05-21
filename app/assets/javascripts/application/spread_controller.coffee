angular.module 'app'
.controller 'SpreadCtrl',
['$scope', '$http', 'AppService', ($scope, $http, AppService)->
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
        $scope.chart = AppService.chartTable resp.data
        $scope.loading = false
        return
    return

  $http.get '/api/tools'
    .then (response)->
      $scope.groups = response.data.groups
      $scope.symbols = response.data.tools
      return

  unless google.visualization
    google.charts.load 'current', {packages: ['corechart']}

  return
]
