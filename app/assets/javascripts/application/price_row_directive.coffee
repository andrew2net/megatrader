angular.module 'app'
.directive 'priceHeader', [->
  templateUrl: 'priceHeader.html'
  restrict: 'A'
]
.directive 'priceRow', [->
  templateUrl: 'priceRow.html'
  restrict: 'A'
  scope: {}
  link: (scope, element, attrs)->
    scope.product = attrs.priceRow
    scope.license = attrs.license.split ','
    scope.description = attrs.description.split(';').map (el)->  el.split ':'
    scope.price = attrs.price
]
