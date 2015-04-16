class HomeController
  @$inject: ['$scope', '$http']

  constructor: (@scope, @http) ->
    @chartOptions =
      options:
        chart:
          type: 'line'
        tooltip:
          shared: true
          crosshairs: true
      title:
        text: ''
      size:
        height: 300
      xAxis:
        type: 'datetime'
      series: []

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
        @chartOptions.series.push @toSeries('Import', res.import)
        @chartOptions.series.push @toSeries('Export', res.export)

  toSeries: (name, items) ->
    data = []
    for item in items
      date = new Date(item.date)
      data.push [Date.UTC(date.getFullYear(), date.getMonth(), date.getDay()), item.value]
    series =
      name: name
      data: data

angular
.module 'home.app'
.controller 'HomeController', HomeController
.requires.push 'ui.grid', 'highcharts-ng'