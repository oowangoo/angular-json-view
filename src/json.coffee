angular.module('json.view',['ng'])
angular.module('json.view').directive('jsonView', ($compile) ->
  directiveDefinitionObject =
    priority: 10
    restrict: 'E'
    replace:true
    scope:{
      object:"="
    }
    template: '''<div class="json-view"></div>'''
    link: (scope, iElement, iAttrs) ->
      objectType = (obj)->
        if angular.isArray(obj)
          return 1;
        else if  angular.isObject(obj)
          return 2;
        else if angular.isString(obj) or angular.isNumber obj
          return 3;
        return 0

      propertyToHTML = (p)->
        ele = '' 
        if p.name
          prix = "<span class='property'>#{p.name}</span>:"
        else 
          prix = ''
        switch objectType(p.value)
          when 1
            ele = "<li>#{prix}<span>" + jsonArray(p.value) + "</span></li>"
          when 2
            ele = "<li>#{prix}<span>" + jsonObject(p.value)  + "</span></li>"
          else
            ele = "<li>#{prix}<span class='type-string'>#{p.value}</span></li>"
        return ele

      jsonObject = (pobj)->
        eleArray = "<span class='before-cls'>{</span><ul class='type-object'>"
        angular.forEach pobj, (value, key) ->
          p = {}
          p.value = value
          p.name = key
          ele = propertyToHTML(p)
          eleArray += ele
        eleArray += "</ul><span class='after-cls'>}</span>"
        return eleArray

      jsonArray = (pArray)->
        eleArray = "<span class='before-cls'>[</span><ul class='type-object'>"
        for pobj in pArray
          p = {}
          p.value = pobj
          ele = propertyToHTML(p)
          eleArray += ele
        eleArray += "</ul><span class='after-cls'>]</span>"

      html  = ""
      switch objectType(scope.object)
        when 1
          html = jsonArray(scope.object)
        when 2
          html = jsonObject(scope.object)
        when 3
          html = '<span class="type-srting" ng-bind="obj"></span>'
        else
          html = '<span class="type" ng-bind="obj"></span>'
      ele = $compile(html)(scope)
      iElement.append(ele)
  return directiveDefinitionObject
)