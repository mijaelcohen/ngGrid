<h1>ngGrid a jqGrid adaptation</h1>
This is a Angular (1.x) adaptation for Jqgrid:  http://www.trirand.com/blog/ 

<h2>Implementation</h2>
Include <code>ngGrid</code> into your module like: 
<code>myModule = angular.module('myModule', ['ngGrid'])</code>
view example: 
<p>
<code>
$scope.url = "http://api.com/get";
</code>
<br>
<code>
$scope.urlEdit = "http://api.com/edit";
</code>
</p>
```HTML
<ng-grid add url="url" edit="urlEdit" delete table-class="table">
  <ng-grid-field name="id_user" label="ID" hidden edit search></ng-grid-field>
</ng-grid>
```

<strong>options:</strong><br>
<code>hidden</code>: to hide or not this field, by default is false<br>
<code>edit</code>: this field is editable or not, by default false<br>
<code>search</code> : to search by this field or not, by default false<br>
