angular.module 'app'
.controller 'DownloadWrapperCtrl', ['$scope', '$location', '$http', '$uibModal',
($scope, $location, $http, $uibModal)->
  params = $location.search()
  $scope.token = params.token

  $scope.success = (resp, filename)->
    headers = resp.headers()
    blob = new Blob [resp.data], {type: headers['content-type']}
    url = URL.createObjectURL blob
    a = document.createElement 'a'
    a.style = "display: none"
    document.body.appendChild(a)
    a.href = url
    a.download = decodeURI filename
    a.target = '_self'
    a.click()
    document.body.removeChild(a)

  $scope.load = (filename)->
    a = document.createElement 'a'
    a.style = "display: none"
    document.body.appendChild(a)
    a.href = "/api/download/#{$scope.token}?file=#{filename}"
    a.download = decodeURI filename
    a.target = '_self'
    a.click()
    document.body.removeChild(a)

  $scope.error = (resp)->
    $uibModal.open {
      templateUrl: 'downloadError.html'
      size: 'sm'
      controller: 'DownloadErrorDialog'
    }

  # $scope.download = (filename)->
  #   $http.get "/api/download/#{$scope.token}", {
  #     params: { file: filename }
  #     responseType: 'arraybuffer'
  #   }
  #   .then $scope.success, $scope.error
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
.directive 'download', ['$http', ($http)->
  {
    templateUrl: 'downloadButton.html'
    scope: true
    controller: ['$scope', '$attrs', ($scope, $attrs)->
      $scope.dwnl = -> $scope.load $attrs.download
        # $scope.loading = true
        # $http.get "/api/download/#{$scope.token}", {
        #   params: { file: $attrs.download }
        #   responseType: 'arraybuffer'
        # }
        # .then (resp)->
        #   $scope.success(resp, $attrs.download)
        #   $scope.loading = false
        # , (resp)->
        #   $scope.error(resp)
        #   $scope.loading = false
    ]
  }
]
