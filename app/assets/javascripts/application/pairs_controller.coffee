angular.module 'app'
.controller 'PairsCtrl', ['$scope', '$http', 'AppService',
($scope, $http, AppService)->
  $scope.timeFrames = ['m1', 'm5', 'm15', 'm30', 'h1', 'h4', 'd1']
  $scope.timeFrame = 'h1'
  $scope.symbols = []
  $scope.selectedSymbols = []
  $scope.pages = []
  $scope.currentPage = 1
  
  $scope.isChecked = (symbol)->
    $scope.selectedSymbols.indexOf(symbol) > -1

  $scope.toggleCheck = (symbol)->
    idx = $scope.selectedSymbols.indexOf(symbol)
    if idx == -1
      $scope.selectedSymbols.push symbol
    else
      $scope.selectedSymbols.splice idx, 1

  $scope.buildCharts = ->
    $scope.pages = [[]]
    $scope.currentPage = 1
    pairCharts()
    return

  $scope.pageChange = ->
    while $scope.pages.length < $scope.currentPage
      $scope.pages.push []
    unless $scope.pages[$scope.currentPage - 1].length
      pairCharts()
    return

  pairCharts = ->
    $scope.loading = true
    symbols = $scope.selectedSymbols.map (sym)-> sym.id
    $http.post('/api/pairs', {symbols: symbols, time_frame: $scope.timeFrame},
      params: {page: $scope.currentPage})
      .then (resp)->
        $scope.totalCharts = resp.data.total
        angular.forEach resp.data.charts, (chart)->
          chartTable = AppService.chartTable chart.data
          # Make chart title.
          positive = []
          negative = []
          for elm in chart.symbols
            if elm.weight < 0
              negative.push "(#{elm.symbol} * #{-elm.weight})"
            else
              positive.push "(#{elm.symbol} * #{elm.weight})"
          title = positive.join(' + ')
          title = title + ' - ' + negative.join(' - ') if negative.length
          chartTable.options.title = title

          $scope.pages[$scope.currentPage - 1].push {
            table: chartTable
            symbols: chart.symbols
          }
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
