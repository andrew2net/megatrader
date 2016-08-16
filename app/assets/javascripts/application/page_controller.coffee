angular.module 'app'
  .controller 'PageCtrl', ['$scope', '$http', ($scope, $http)->

    $scope.products = {}
    input_prods = document.querySelectorAll('div.radio label input[type=radio]')
    for p, i in input_prods
      ref = p.getAttribute 'value'
      $scope.product = ref if i == 0
      price = /([\d\s]+)(.*)/.exec p.nextSibling.nodeValue
      $scope.currency = price[2]
      $scope.products[ref] = {
        price: price[1].replace /\s/g, ''
        signature: p.getAttribute 'data-sign'
      }

    return
  ]
