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
      readNames  : if $attrs.readNames then true else false
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
    addingRow  : {}
    searchOptions : []
    searchString  : ""
    searchFilter  : ""
    deletingRow   : {}
    readNames     : attrs.readNames
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

    addRow : ->
      @.action = ""
      if @.editUrl
        params = angular.copy(@.addingRow)
        @.loading = true
        params.oper = "add"
        $http.get(@.editUrl, params:params)
        .success (response) =>
          @.getData(@.paginator.page)
          @.unsetAction()
          @.loading = false
      else
        console.error "Edit url not provided!"

    setAddingRow: ->
      @.action = "add"
      for header in @.fields
        switch header.type
          when "bool" then @.addingRow["#{header.name}"] = false
          else @.addingRow["#{header.name}"] = ""

    getData : (page) ->
      @.loading = true
      @.paginator.page = page?=0
      params =
        page        : @.paginator.page
        searchField : @.searchFilter.name
        searchOper  : "eq"
        searchString: @.searchString
        sdix        : @.searchFilter.name
        sord        : "asc"
      $http.get(@.url, params: params)
      .success (response) =>
        @.rows = []
        @.action = ""
        if @.readNames
          @.rows = response.rows
        else
          for row in response.rows
            @.rows.push {}
            idsCounter = 0
            for index, header of @.fields
              if header.id
                idsCounter++
                @.rows[@.rows.length-1]["#{header.name}"] = row.id
              else
                switch header.type
                  when "date" then @.rows[@.rows.length-1]["#{header.name}"] = new Date(row.cell[index - idsCounter])
                  else @.rows[@.rows.length-1]["#{header.name}"] = row.cell[index - idsCounter]

        @.paginator.totalPages = response.total
        @.paginator.page       = response.page
        @.records              = response.records
        @.paginator.pages      = @.paginator.setTotalPages()
        @.loading              = false

    editRow : () ->
      #clean all the angular bullshit
      if @.editUrl
        params = angular.copy(@.editingRow)
        @.loading = true
        params = @.adaptEdit(params)
        params.oper = "edit"
        $http.get(@.editUrl, params:params)
        .success (response) =>
          @.getData(@.paginator.page)
          @.unsetAction()
          @.loading = false
      else
        console.error "Edit url not provided!"
    adaptEdit : (params) ->
      for header in @.fields
        if header.onOff
          params[header.name] = if params[header.name] then  "on" else "off"
      params

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
      position = @.fields.length
      @.fields.push
        onOff     : header.onOff?
        id        : header.id?
        type      : if header.type? then header.type else "none"
        position  : position
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

    deleteRow : ->
      if @.editUrl
        params = angular.copy(@.deletingRow)
        @.loading = true
        params.oper = "del"
        $http.get(@.editUrl, params:params)
        .success (response) =>
          @.getData(@.paginator.page)
          @.unsetAction()
          @.loading = false
      else
        console.error "Edit url not provided!"

    setDeleteRow : (row) ->
      @.action = "delete"
      @.deletingRow = row
