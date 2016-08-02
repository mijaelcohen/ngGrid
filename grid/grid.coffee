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
    url    :  "="
    editUrl   :  "="
  controller : ($scope, $element, $attrs) ->
    $scope.grid = new Grid
      tableClass : $attrs.tableClass
      url        : $scope.url
      editUrl    : $scope.editUrl?=false
      delete     : if $attrs.delete then true else false
      add        : if $attrs.add then true else false
      edit       : if $attrs.edit then true else false
      search     : if $attrs.search then true else false
    $scope.grid.getData()
    @.getGrid = ->
      $scope.grid

##GRID CLASS
ngGrid.service 'Grid', ($http) ->
  $grid = (attrs) ->
    loading    : false
    editingRow : {}
    tableClass : attrs.tableClass
    fields     : []
    url        : attrs.url
    editUrl    : attrs.editUrl
    rows       : []
    add        : attrs.add
    edit       : attrs.edit
    delete     : attrs.delete
    search     : attrs.search
    action     : ""
    searchOptions : []
    searchString  : ""
    searchFilter  : ""
    paginator :
      page :  0
      totalPages : 0
      pages : []
      setTotalPages : () ->
        min = @.page  - 5
        max = @.page  + 5

        min = 1 if min < 1

        max = @.totalPages if max > @.totalPages

        max = 1 if max < 1

        _.range(min, max + 1)

    getData : (page) ->
      @.loading = true
      @.paginator.page = page?=0
      par =
        page        : @.paginator.page
        searchField : @.searchFilter.name
        searchOper  : "eq"
        searchString: @.searchString
        sdix        : @.searchFilter.name
        sord        : "asc"
      $http.get(@.url, params: par)
      .success (response) =>
        @.rows                 = response.rows
        @.paginator.totalPages = response.total
        @.paginator.page       = response.page
        @.records              = response.records
        @.paginator.pages      = @.paginator.setTotalPages()
        @.loading              = false

    editRow : () ->
      par = angular.copy(@.editingRow)
      par.oper = "edit"
      @.loading = true
      $http.get(@.editUrl, params:par)
      .success (response) =>
        @.getData(@.paginator.page)
        @.unsetAction()
        @.loading = false

    deleteRow : () ->
      par = angular.copy(@.editingRow)
      par.oper = "del"
      @.loading = true
      $http.get(@.editUrl, params:par)
      .success (response) =>
        @.getData()
        @.unsetAction()
        @.loading = false

    setEditingRow : (row) ->
      @.action = "edit"
      @.editingRow = row

    addHeader : (header) ->
      @.fields.push
        editAs    : header.editAs
        type      : if header.type? then header.type else "none"
        position  : header.position?=false
        required  : header.required?
        hidden    : header.hidden?
        edit      : header.edit?
        search    : header.search?
        name      : header.name
        label     : header.label
      if header.search?
        @.searchOptions.push
          name       : header.name
          label      : header.label
        @.searchFilter =
          name      : header.name
          label     : header.label

    unsetAction : () ->
      @.action = ""
