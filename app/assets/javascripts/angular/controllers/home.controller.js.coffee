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
        { name: 'date', displayName: 'Month' },
        { name: 'value', displayName: 'Value' },
        { name: 'shipwt', displayName: 'Ship Weight' },
        { name: 'freight_charges', displayName: 'Freight Charges'}
      ]

    @exportGridOptions =
      minRowsToShow: 5
      enableHorizontalScrollbar: 0
      paginationPageSizes: [25, 50, 75],
      paginationPageSize: 25,
      columnDefs: [
        { name: 'date', displayName: 'Month' },
        { name: 'value', displayName: 'Value' },
        { name: 'shipwt', displayName: 'Ship Weight' },
        { name: 'freight_charges', displayName: 'Freight Charges'}
      ]

    @http.get Routes.api_summary_path(format: 'json')
      .success (res) =>
        @importGridOptions.data = res.import
        @exportGridOptions.data = res.export

angular
.module 'home.app'
.controller 'HomeController', HomeController
.requires.push 'ui.grid'