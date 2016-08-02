<h1>ngGrid a jqGrid adaptation</h1>
This is a Angular (1.x) adaptation for Jqgrid:  http://www.trirand.com/blog/

<h2>Implementation</h2>
this is a really early version (use at your own risk). I havent made a beta release yet, but im fully working on this plugin. (so keep an eye on this repo :) )
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

<strong>ng-grid-field options:</strong><br>
<code>hidden</code>: to hide or not this field, by default is false<br>
<code>edit</code>: this field is editable or not, by default false<br>
<code>search</code> : to search by this field or not, by default false<br>
<code>position</code> : if field is on array then use this position of such array<br>
<code>name</code>: name of the parameter comming on the api<br>
<code>label</code>: name visible of the parameter<br>
<code>required</code>: if this field is required when editing<br>
<code>type</code>: there are 3 types <code>bool</code> <code>date</code> and <code>none</code> (none is default)<br> <code>editAs</code>: if you need to edit a field with a diferent parameter name you can change it here
