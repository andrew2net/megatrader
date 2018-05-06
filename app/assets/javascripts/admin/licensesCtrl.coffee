angular.module 'admin'
.controller 'LicenseCtrl', ['$scope', 'Licenses', '$http', '$timeout', '$filter',
  ($scope, Licenses, $http, $timeout, $filter)->
    $scope.licenses = Licenses.query (data)->
      for l in data
        l.date_end = new Date l.date_end if l.date_end

    $scope.addLicense = ->
      $scope.form.$setUntouched()
      $scope.license = new Licenses product_id: $scope.products[0].id
      $scope.licensesGridApi.selection.clearSelectedRows()
      $scope.selectedLicense = null
      $timeout ->
        document.getElementById('input-email').focus()
      return

    $scope.editLicense = ->
      $scope.form.$setPristine()
      $scope.license = angular.copy $scope.selectedLicense
      return

    $scope.openDateInput = -> $scope.dateInputOpened = true

    $scope.saveLicense = ->
      if $scope.license.id
        idx = $scope.licenses.indexOf $scope.selectedLicense
        $scope.license.$update (val)->
          if angular.equals {}, val.errors
            val.date_end = new Date val.date_end if val.date_end
            $scope.licenses.splice idx, 1, val
            $scope.selectedLicense = null
            $scope.license = null
          return
      else
        $scope.license.$save (val)->
          if angular.equals {}, val.errors
            val.date_end = new Date val.date_end if val.date_end
            $scope.licenses.push val
            $scope.license = null
          return
      return

    $scope.delLicense = ->
      if confirm 'Delete "' + $scope.selectedLicense.email + '" license?'
        idx = $scope.licenses.indexOf $scope.selectedLicense
        $scope.license = null
        $scope.selectedLicense.$remove ->
          $scope.licenses.splice idx, 1
          $scope.selectedLicense = null
      return

    $scope.getProduct = (id)->
      p = $filter('filter')($scope.products, {id: id}, true)
      if p and p.length then p[0].name else ''

    $scope.licensesGridOptions = {
      multiSelect: false
      noUnselect: true
      enableRowSelection: true
      modifierKeysToMultiSelect: false
      enableRowHeaderSelection: false
      columnDefs: [
        {name: 'E-mail', field: 'email'}
        {
          name: 'Product'
          field: 'product'
          cellTemplate: """
          <div class="ui-grid-cell-contents" title="TOOLTIP">
            {{grid.appScope.getProduct(row.entity.product_id)}}
          </div>
          """
        }
        { name: 'Key errors', field: 'key_errors', width: 100 }
        {
          name: 'Blocked'
          field: 'blocked'
          type: 'boolean'
          width: 100
          cellTemplate: """
          <div class="ui-grid-cell-contents text-center" title="TOOLTIP">
            {{row.entity.blocked ? '&\#10004' : ''}}
          </div>
          """
        }
        {
          name: 'Date end'
          field: 'date_end'
          type: 'date'
          width: 100
          cellFilter: 'date : "dd-MM-yyyy"'
        }
      ]
      data: 'licenses'
      onRegisterApi: (gridApi)->
        $scope.licensesGridApi = gridApi
        gridApi.selection.on.rowSelectionChanged $scope, (newRow, oldRow)->
          getLogs newRow.entity.id
          $scope.selectedLicense = newRow.entity
          $scope.license = null
          return
    }

    $http.get '/admin/licenses/products'
      .then (resp)-> $scope.products = resp.data

    $http.get '/admin/users/index.json'
    .then (resp)-> $scope.users = resp.data

    $scope.logs = []
    $scope.logsGridOptions = {
      columnDefs: [
        {name: 'IP', field: 'ip'}
        {
          name: 'Date', field: 'created_at', type: 'date'
          cellFilter: 'date:"dd-MM-yyyy hh:mm:ss"'
        }
      ]
      data: 'logs'
    }

    getLogs = (license_id)->
      $scope.loadingLogs = true
      $scope.logs = []
      $http.get "/admin/licenses/#{license_id}/logs"
        .then (resp)->
          $scope.logs = resp.data.map (l)->
            l.created_at = new Date l.created_at
            l
          $scope.loadingLogs = false
          return
      return
    return
]
.factory 'Licenses', ['$resource', ($resource)->
  $resource '/admin/licenses/:id.json', {id: '@id'}, {
    update: { method: 'PUT' }
  }
]
