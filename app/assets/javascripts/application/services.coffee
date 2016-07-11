angular.module 'app'
.filter 'percentage', ['$filter', ($filter)->
  (input)->
    if input == undefined
      ''
    else
      $filter('number')(input * 100, 0) + '%'
]
.factory 'AppService', ['$window', ($window)->
  {
  chartTable: (chart)->

    formatStringData = (strData, format)->
      strData.replace(/(\d{2})(\d{2})(\d{4})(\d{2})(\d{2})\d*/, format)

    data = new google.visualization.DataTable()
    data.addColumn('number', 'Date')
    data.addColumn('number', 'Value')
    data.addColumn({ type: 'string', role: 'tooltip' })

    # Index of date in chart's element array.
    dateIdx = chart[0].length - 1 if chart

    # Index of value in chart's element array.
    valueIdx = dateIdx - 1

    # If date index is 2 or more then chart's elements contain index.
    if dateIdx > 1

      # Calc breackpoint for x-axis label.
      ticksInterval = chart[chart.length - 1][0] / 5 - 1
    else
      ticksInterval = chart.length / 5 - 1
    ticks = []
    t = -1
    for value, i in chart
      date = formatStringData value[dateIdx], "$1-$2-$3 $4:$5"
      index = if dateIdx > 1 then value[0] else i

      # Add x-axis label if index reach next breackpoint.
      if index > t
        t = t + ticksInterval
        dateAxis = formatStringData value[dateIdx], "$1-$2-$3"
        ticks.push { v: index, f: dateAxis }

      tooltip = 'Date: ' + date + ' Value: '
      data.addRow [index, parseFloat(value[valueIdx]), tooltip + value[valueIdx]]

    {data: data, options: {hAxis: {ticks: ticks}, legend: {position: 'none'}
    chartArea: {left: 50, top: 25, width: '90%', height: '83%'}}}
  }
]
.directive 'n4Chart', [ ->
  {
  scope: { n4Chart: '=' }
  link: (scope, element)->
    chart = undefined
    scope.$watch 'n4Chart', ->
      if scope.n4Chart
        unless chart
          chart = new google.visualization.LineChart element[0]
        chart.draw scope.n4Chart.data, scope.n4Chart.options
        return
      # scope.n4Chart.redraw = (data)-> chart.draw data.data, data.options
      # scope.n4Chart.clear = -> chart.clearChart()
    return
  }
]
.directive 'stringToNumber', ->
  {
    require: 'ngModel',
    link: (scope, element, attrs, ngModel)->
      ngModel.$parsers.push((value)->
        '' + value
      )
      ngModel.$formatters.push((value)->
        parseFloat(value, 10)
      )
  }
