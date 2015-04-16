class HomeController
  @$inject: ['$scope', '$http']

  constructor: (@scope, @http) ->
    @importGridOptions =
      enableAutoResizing: true
      minRowsToShow: 5
      enableHorizontalScrollbar: 0
      paginationPageSizes: [25, 50, 75],
      paginationPageSize: 25,
      columnDefs: [
        { name: 'date', displayName: 'Month', cellFilter: 'date:"MMMM, yyyy"' },
        { name: 'value', displayName: 'Value', cellFilter: 'currency'},
        { name: 'shipwt', displayName: 'Ship Weight' },
        { name: 'freight_charges', displayName: 'Freight Charges', cellFilter: 'currency'}
      ]

    @exportGridOptions =
      minRowsToShow: 5
      enableHorizontalScrollbar: 0
      paginationPageSizes: [25, 50, 75],
      paginationPageSize: 25,
      columnDefs: [
        { name: 'date', displayName: 'Month', cellFilter: 'date:"MMMM, yyyy"' },
        { name: 'value', displayName: 'Value', cellFilter: 'currency'},
        { name: 'shipwt', displayName: 'Ship Weight' },
        { name: 'freight_charges', displayName: 'Freight Charges', cellFilter: 'currency'}
      ]

    @http.get Routes.api_summary_path(format: 'json')
      .success (res) =>
        @importGridOptions.data = res.import
        @exportGridOptions.data = res.export

angular
.module 'home.app'
.controller 'HomeController', HomeController
.requires.push 'ui.grid'