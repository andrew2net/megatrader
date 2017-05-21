angular.module 'admin'
.controller 'MessagesCtrl', ['$scope', '$http', ($scope, $http)->
  $scope.messages = []
  $scope.messagesGrid = {
    enableRowSelection: true
    enableFullRowSelection: true
    multiSelect: false
    noUnselect: true
    selectionRowHeaderWidth: 0
    columnDefs: [
      {field: 'name'}
      {field: 'email'}
      {field: 'phone', width: '130'}
      {field: 'subject'}
      {
        name: 'Date'
        field: 'created_at'
        format: 'date'
        cellFilter: 'date:"dd-MM-yyyy hh:mm"'
        width: '130'
      }
    ]
    data: 'messages'
    onRegisterApi: (gridApi)->
      gridApi.selection.on.rowSelectionChanged $scope, (row, event)->
        $scope.text = row.entity.text
  }
  $http.get '/admin/messages/index.json'
  .then (resp)->
    $scope.messages = resp.data
    for m in $scope.messages
      m.created_at = new Date m.created_at
]
