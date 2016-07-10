angular.module 'app'
.controller 'SpreadCtrl',
['$scope', '$timeout', '$http', '$filter', '$location', 'AppService',
($scope, $timeout, $http, $filter, $location, AppService)->
  $scope.timeFrames = ['m1', 'm5', 'm15', 'm30', 'h1', 'h4', 'd1']
  $scope.symbols = []
  $scope.selectedSymbols = []
  path = $location.path()

  urlParams = $location.search()
  # Get timeframe from url params.
  _timeFrame = if urlParams.TimeFrame and $scope.timeFrames.indexOf(urlParams.TimeFrame) > 0
    urlParams.TimeFrame
  else
    $scope.timeFrames[4]

  $scope.timeFrame = (newValue)->
    if arguments.length
      param = if $scope.timeFrames.indexOf(newValue) != 4 then newValue
      $location.search('TimeFrame', param).replace()
      _timeFrame = newValue
    else
      _timeFrame
  
  $scope.isChecked = (symbol)->
    $scope.selectedSymbols.indexOf(symbol) > -1

  $scope.toggleCheck = (symbol)->
    idx = $scope.selectedSymbols.indexOf(symbol)
    if idx == -1
      $scope.selectedSymbols.push symbol
      $location.search(symbol.name, symbol._weight).replace()
    else
      $scope.selectedSymbols.splice idx, 1
      $location.search(symbol.name, null).replace()
    return

  $scope.spreadChart = ->
    $scope.loading = true
    symbols = {}
    for s in $scope.selectedSymbols
      symbols[s.id] = s._weight

    $http.post '/api/spread', {symbols: symbols, time_frame: _timeFrame}
      .then (resp)->
        if resp.data and resp.data.length
          $scope.chart = AppService.chartTable resp.data
        else
          $scope.chart = null
        $scope.loading = false
        return
    return

  setDefault = (sym, w)->
    tool = $filter('filter')($scope.symbols, {name: sym}, true)
    if tool.length
      tool[0]._weight = w
      # $scope.selectedSymbols.push tool[0]
      $scope.toggleCheck tool[0]
    return
  
  getSetWeight = (newValue)->
    if arguments.length
      w = unless isNaN parseFloat(newValue) then newValue
      $location.search this.name, w
      this._weight = if newValue == '-' then newValue else w
    else
      this._weight

  $scope.$watch ->
    $location.path()
  , (p)->
    $timeout ->
      location.reload() unless p == path
      path = p
      return
    console.log path
    return

  $http.get '/api/tools'
    .then (response)->
      $scope.groups = response.data.groups
      $scope.symbols = response.data.tools
      for s in $scope.symbols
        s.weight = getSetWeight
      angular.forEach urlParams, (v, k)->
        s = $filter('filter')($scope.symbols, {name: k}, true)
        if s.length
          s[0]._weight = v
          $scope.toggleCheck s[0]
        return

      unless $scope.selectedSymbols.length
        setDefault 'AUDUSD', '1.7'
        setDefault 'EURUSD', '-0.6'
        setDefault 'NZDUSD', '4'

      google.charts.setOnLoadCallback $scope.spreadChart
      return

  unless google.visualization
    google.charts.load 'current', {packages: ['corechart']}

  return
]
