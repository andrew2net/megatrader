angular.module 'app'
.controller 'DownloadCtrl', ['$scope', '$uibModal',
($scope, $uibModal)->
  $scope.openDialog = ->
    dialog = $uibModal.open {
      templateUrl: 'downloadDialog.html'
      controller: 'DownloadDialogCtrl'
    }
    dialog.result.then (email)->
]
.controller 'DownloadDialogCtrl', ['$scope', '$http', '$uibModalInstance',
'$timeout',
($scope, $http, $uibModalInstance, $timeout)->
  $scope.agree = true

  $timeout -> document.getElementById('user-email').focus()

  $scope.ok = ->
    $scope.sendingEmail = true
    l = window.location.pathname.match(/^\/(en|ru)\//)[1]
    $http.post "/#{l}/users/email", email: $scope.email
    .then ->
      $scope.sendingEmail = false
      $scope.emailSent = true

  $scope.cancel = -> $uibModalInstance.dismiss 'cancel'
]
