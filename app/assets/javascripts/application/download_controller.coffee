angular.module 'app'
.controller 'DownloadWrapperCtrl', ['$scope', '$location', '$http', '$uibModal',
($scope, $location, $http, $uibModal)->
  params = $location.search()
  $scope.token = params.token
  $scope.download = (filename)->
    $http.get "/api/download/#{$scope.token}", {
      params: { file: filename }
      responseType: 'arraybuffer'
    }
      .then (resp)->
        headers = resp.headers()
        blob = new Blob [resp.data], {type: headers['content-type']}
        url = URL.createObjectURL blob
        a = document.createElement 'a'
        a.style = "display: none"
        document.body.appendChild(a)
        a.href = url
        a.download = decodeURI filename
        a.target = '_blank'
        a.click()
        document.body.removeChild(a)
        return
      , (resp)->
        $uibModal.open {
          templateUrl: 'downloadError.html'
          size: 'sm'
          controller: 'DownloadErrorDialog'
        }
]
.controller 'DownloadErrorDialog', ['$scope', '$uibModalInstance',
($scope, $uibModalInstance)->
  $scope.cancel = -> $uibModalInstance.dismiss 'cancel'
]
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
