angular.module 'admin'
.controller 'LicenseCtrl', ['$scope', 'Licenses', '$http', '$timeout', '$filter',
  ($scope, Licenses, $http, $timeout, $filter)->
    $scope.licenses = Licenses.query()

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

    $scope.saveLicense = ->
      if $scope.license.id
        idx = $scope.licenses.indexOf $scope.selectedLicense
        $scope.license.$update (val)->
          $scope.licenses.splice idx, 1, val
          $scope.selectedLicense = null
          return
      else
        $scope.license.$save (val)->
          $scope.licenses.push val
          return
      $scope.license = null
      return

    $scope.delLicense = ->
      if confirm 'Delete "' + $scope.selectedLicense.email + '" license?'
        idx = $scope.licenses.indexOf $scope.selectedLicense
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
        {
          name: 'Blocked'
          fielld: 'blocked'
          type: 'boolean'
          cellTemplate: """
          <div class="ui-grid-cell-contents text-center" title="TOOLTIP">
            {{row.entity.blocked ? '&#10004' : ''}}
          </div>
          """
        }
      ]
      data: 'licenses'
      onRegisterApi: (gridApi)->
        $scope.licensesGridApi = gridApi
        gridApi.selection.on.rowSelectionChanged $scope, (newRow, oldRow)->
          $scope.selectedLicense = newRow.entity
          $scope.license = null
          return
    }
    $http.get '/admin/licenses/products'
      .then (resp)->
        $scope.products = resp.data
        return

    return
]
.factory 'Licenses', ['$resource', ($resource)->
  $resource '/admin/licenses/:id', {id: '@id'}, {
    update: { method: 'PUT' }
  }
]
