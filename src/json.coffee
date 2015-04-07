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
      ellipsis = "<span class='ellipsis'>...</span>"
      propertyToHTML = (p)->
        ele = '' 
        if p.name
          prix = "<span class='property'>#{p.name}</span>: "
        else 
          prix = ''
        collapser = "<span class='abs-left collapser' ng-click='toggle($event)'></span>"
        
        switch objectType(p.value)
          when 1
            liCls = if p.value and p.value.length > 0 then 'collapsible' else ''
            ele = "<li class='#{liCls}'><div class='content-warp'>#{collapser}#{prix}<span>" + jsonArray(p.value) + "</span></div></li>"
          when 2
            liCls = 'collapsible'
            liEle = angular.element("<li></li>")
            warp = angular.element("<div class='content-warp'></div>")
            warp.append(collapser)
            warp.append(prix)
            objecEle = jsonObject(p.value,liEle)
            warp.append(objecEle)
            liEle.append(warp)
            ele = liEle[0].outerHTML
          else
            ele = "<li><div class='content-warp'>#{prix}<span class='type-string'>#{p.value}</span></div></li>"
        return ele

      jsonObject = (pobj,parentEle)->
        eleArray = "<span class='before-cls'>{</span>#{ellipsis}<ul class='type type-object'>"
        hasProperty = false
        angular.forEach pobj, (value, key) ->
          if !hasProperty
            hasProperty = true
            if parentEle
              parentEle.addClass("collapsible")
          p = {}
          p.value = value
          p.name = key
          ele = propertyToHTML(p)
          eleArray += ele
        eleArray += "</ul><span class='after-cls'>}</span>"
        return eleArray

      jsonArray = (pArray)->
        eleArray = "<span class='before-cls'>[</span>#{ellipsis}<ul class='type type-array'>"
        for pobj in pArray
          p = {}
          p.value = pobj
          ele = propertyToHTML(p)
          eleArray += ele
        eleArray += "</ul><span class='after-cls'>]</span>"

      init = ()->
        iElement.html('')
        html  = ""
        switch objectType(scope.object)
          when 1
            html = jsonArray(scope.object)
          when 2
            html = jsonObject(scope.object)
          when 3
            html = '<span class="type type-srting" ng-bind="obj"></span>'
          else
            html = '<span class="type" ng-bind="obj"></span>'
        ele = $compile(html)(scope)
        iElement.append(ele)

      scope.toggle = (event)->
        target =event.target
        #jqite no support parents method
        li = angular.element(target).parent().parent() 
        li.toggleClass("selected")
        event.stopPropagation()
        return ;
      scope.$watch('object',()->
        init()
      )
      init()
  return directiveDefinitionObject
)