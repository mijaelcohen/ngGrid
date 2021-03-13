<h1>ngGrid a jqGrid adaptation</h1>
This is a Angular directive (1.x) adaptation for jQgrid:  http://www.trirand.com/
The Directive does not use jQgrid plugin, only replicates its behavior towards backend structure of a jQgrid table.

<h2>Implementation</h2>
Im not working at this proyect, use at own risk<br>
Include <code>ngGrid</code> into your module like:
<code>myModule = angular.module('myModule', ['ngGrid'])</code><br>
code example:
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
<h3></h3>
<strong>ng-grid options</strong><br>
<code>add</code> : option of adding a new row <br>
<code>read-names</code> : use params names instead of getting the values the normal way<br>
<code>edit</code> : option of edit any row (only editable fields)<br>
<code>delete</code> : option of deleting rows<br>
<code>table-class</code> : you can add multiple classes to the table, like <code>table-class="table table-red"</code><br>

<br>
<strong>ng-grid-field options:</strong><br>
<code>hidden</code>: to hide or not this field, by default is false<br>
<code>edit</code>: this field is editable or not, by default false<br>
<code>search</code> : to search by this field or not, by default false<br>
<code>id</code> : this param is the id
<code>name</code>: name of the parameter comming on the api<br>
<code>label</code>: name visible of the parameter<br>
<code>required</code>: if this field is required when editing<br>
<code>type</code>:<br>
 types : <code>bool</code>,<code>date</code>,<code>password</code>,<code>none</code> (none is default)<br>
<code>onoff</code>: if you are using <code>type="bool"</code> onoff attribute changes the true/false value to "on"/"off" strings
