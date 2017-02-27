angular.module 'app'
.directive 'buyBlock', [->
  templateUrl: 'buyBlock.html'
  scope: {}
  link: (scope, element, attrs)->
    element.addClass 'buy-block'
    element.addClass 'text-center'
    scope.licenseName = attrs.buyBlock
    scope.price = attrs.buyPrice
    scope.infos = attrs.buyInfo.split ','
    scope.href = attrs.buyHref
]
