scripts = document.getElementsByTagName("script")
currentScriptPath = scripts[scripts.length-1].src

ngGrid = angular.module 'ngGrid',[]
##CHILD DIRECTIVE
ngGrid.directive 'ngGridField', ->
  restrict : "E"
  require: '^ngGrid'
  link     : (scope, element, attrs, controller) ->
    grid = controller.getGrid()
    grid.addHeader attrs

##MAIN DIRECTIVE
ngGrid.directive 'ngGrid', (Grid) ->
  templateUrl : currentScriptPath.replace('grid.js', 'table.html')
  transclude: true
  scope       :
    url :  "="
    edit   :  "="
  controller : ($scope, $element, $attrs) ->
    $scope.grid = new Grid
      tableClass : $attrs.tableClass
      url        : $scope.url
      edit       : $scope.edit?=false
    $scope.grid.getData()
    @.getGrid = ->
      $scope.grid

##GRID CLASS
ngGrid.service 'Grid', ($http) ->
  $grid = (attrs) ->
    editingRow : {}
    tableClass : attrs.tableClass
    fields     : []
    url        : attrs.url
    edit       : attrs.edit
    rows       : []
    paginator :
      page :  0
      pages : 0
    getData : () ->
      $http.get(@.url)
      .success (response) =>
        @.rows             = response.rows
        @.paginator.pages  = response.total
        @.paginator.page   = response.page
        @.records          = response.records
    editRow : (row) ->
      $http.get(@.edit)
    setEditingRow : (row) ->
      @.editingRow = row

    addHeader : (header) ->
      @.fields.push
        hidden    : header.hidden?
        edit      : header.edit?
        search    : header.search?
        parameter : header.name
        name      : header.label
