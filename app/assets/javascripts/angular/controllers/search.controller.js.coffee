class SearchController
  gridOptions:
    minRowsToShow: 31
    enableSorting: false
    enableColumnMenus: false
    paginationPageSizes: [20, 30, 50]
    paginationPageSize: 30
    pageIndex: 0
    pageSize: 30
    useExternalPagination: true
    columnDefs: [
      {name: 'trade_type', displayName: 'Trade Type'}
      {name: 'date', displayName: 'Date'}
      {name: 'value', displayName: 'Value'}
      {name: 'shipwt', displayName: 'Ship Weight'}
      {name: 'freight_charges', displayName: 'Freight Charges'}
    ]
    data: []

  countries: []
  country: null

  ports: []
  port: null

  states: []
  state: null

  commodities: []
  commodity: null

  @$inject: ['$scope', '$http', '$q', '$templateCache']
  constructor: (@scope, @http, @q, @templateCache) ->
    @gridOptions.onRegisterApi = @attachGridEventHandler
    @q.all [@loadCountries(), @loadStates(), @loadCommodities(), @loadPorts()]
    .then () =>
      @loadTrades()

  attachGridEventHandler: (gridApi) =>
    gridApi.pagination.on.paginationChanged @scope, (newPage, pageSize) =>
      @gridOptions.pageIndex = newPage
      @gridOptions.pageSize = pageSize
      @loadTrades()

  loadTrades: () ->
    criteria = {
      page_index: @gridOptions.pageIndex
      page_size: @gridOptions.pageSize
    }
    criteria.country_id = @country.id if @country
    criteria.state_id = @state.id if @state
    criteria.port_id = @port.id if @port
    criteria.commodity_id = @commodity.id if @commodity
    @http.get '/api/trades',
      cache: @templateCache
      params: criteria
    .success (res) =>
      @gridOptions.data = res.trades
      @gridOptions.totalItems = res.total_items

  loadCountries: ->
    @http.get '/api/countries',
      cache: @templateCache
    .success (res) =>
      @countries = res.search

  loadPorts: ->
    @http.get '/api/ports',
      cache: @templateCache
    .success (res) =>
      @ports = res.search

  loadStates: ->
    @http.get '/api/states',
      cache: @templateCache
    .success (res) =>
      @states = res.search

  loadCommodities: ->
    @http.get '/api/commodities',
      cache: @templateCache
    .success (res) =>
      @commodities = res.search

angular
.module 'search.app'
.controller 'SearchController', SearchController
.run ['$templateCache', ($templateCache) ->
  $templateCache.put("bootstrap/match.tpl.html","<div class=\"ui-select-match\" ng-hide=\"$select.open\" ng-disabled=\"$select.disabled\" ng-class=\"{\'btn-default-focus\':$select.focus}\"><span tabindex=\"-1\" class=\"btn btn-default form-control ui-select-toggle\" aria-label=\"{{ $select.baseTitle }} activate\" ng-disabled=\"$select.disabled\" ng-click=\"$select.activate()\" style=\"outline: 0;\"><span ng-show=\"$select.isEmpty()\" class=\"ui-select-placeholder text-muted\">{{$select.placeholder}}</span> <span ng-hide=\"$select.isEmpty()\" class=\"ui-select-match-text pull-left\" ng-class=\"{\'ui-select-allow-clear\': $select.allowClear && !$select.isEmpty()}\" ng-transclude=\"\"></span> <i class=\"caret pull-right\" ng-click=\"$select.toggle($event)\"></i> <a ng-show=\"$select.allowClear && !$select.isEmpty()\" aria-label=\"{{ $select.baseTitle }} clear\" style=\"margin-right: 10px\" ng-click=\"$select.clear($event)\" class=\"btn btn-xs btn-link pull-right\"><i class=\"fa fa-times\" aria-hidden=\"true\"></i></a></span></div>")
]
.requires.push 'ui.grid', 'ui.grid.pagination', 'ui.grid.autoResize', 'ui.select', 'ngSanitize'