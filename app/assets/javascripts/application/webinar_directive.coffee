angular.module 'app'
.directive 'webinar', [->
  templateUrl: 'webinar.html'
  scope: {}
  controller: ['$scope', '$uibModal', ($scope, $uibModal)->
    $scope.signUp = ->
      $uibModal.open {
        templateUrl: 'webinarModal.html'
        controller: 'WebinarModalCtrl'
      }
  ]
]
.controller 'WebinarModalCtrl', [
  '$scope',
  '$uibModalInstance',
  '$http',
  ($scope, $uibModalInstance, $http)->
    $scope.send_news = true
    l = window.location.pathname.match(/^\/(en|ru)\//)[1]
    $scope.sendingEmail = true
    $http.get '/api/webinars', params: { locale: l }
      .then (resp)->
        $scope.webinars = resp.data
        $scope.webinarId = resp.data[0].id
        $scope.sendingEmail = false

    $scope.ok = ->
      $scope.sendingEmail = true
      $http.post '/api/webinar_reg', {
        email: $scope.email,
        webinar_id: $scope.webinarId
        send_news: $scope.send_news
      }, params: { locale: l }
        .then ->
          $scope.emailSent = true
          $scope.sendingEmail = false

    $scope.cancel = -> $uibModalInstance.dismiss 'cancel'
]
