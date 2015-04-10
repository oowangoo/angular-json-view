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
        if angular.isNumber(obj)
          return 1
        else if angular.isString(obj) 
          return 2;
        else if angular.isArray(obj) # if type > 2 则是object
          return 3;
        else if  angular.isObject(obj)
          return 4;
        return 0

      objectHTML = (@name,@value,@$parent)->
        if @$parent
          @$parent.child = @
          level = @$parent.getLevel() + 1
        else 
          level = 0
        #防止object中出现无限递归
        @getLevel = ()->
          return level
        
        kuohao = [
          ['[',']']
          ['{','}']
        ]

        @type = objectType(@value)
        that = @
        #折叠对象        
        collapser = "<span class='abs-left collapser' ng-click='toggle($event)'></span>"
        #每行间分隔对象
        span_spilt = "<span class='spilt'>,</span>"

        getPropertyHTML = ()->
          if that.name 
            "<span class='property'>#{that.name}</span>: "
          else 
            ''
        getRootElement = ()->
          li = angular.element("<li class='type'></li>")
          if that.value
            li.addClass("type-" + that.value.constructor.name)
          warp = angular.element("<div class='content-warp'></div>")
          warp.append(getPropertyHTML())
          li.append(warp)
          that.root = li 
          that.warp = warp

        typeDefault = ()->
          that.warp.append('<span class="value">' + that.value + '</span>')

        typeObject = ()->
          valueSpan = angular.element("<span class='value'></span>")
          # vl.append("<span class='before-cls'>#{kuohao[that.type - 3][0]}</span>")
          that.warp.append(valueSpan)
          if that.hasChild
            that.root.addClass("collapsible").append(collapser)
            ul = angular.element("<ul></ul>")
            array = []
            angular.forEach(that.value,(v,k)->
              name = k
              if that.type is 3
                name = null
              h = new objectHTML(name,v,that)
              li = h.toHTML()
              ul.append(li)
            )
            valueSpan.append(ul)
            # if array.length > 0
            #   last = array[array.length - 1]
            #   # last.find('span.spilt').remove()  #会删除子集下的
            #   cl = last.children().children() #li>div>span.name+span.value...
            #   angular.element(cl[cl.length - 1 ]).remove() #最后一个元素，
            # for ai in array
            #   ul.append(ai)
            # that.warp.append(ul)
            # that.warp.append("<span class='ellipsis'>...</span>")
          # that.warp.append("<span class='after-cls'>#{kuohao[that.type - 3][1]}</span>")

        hasOwnerChild = ()->
          if that.type < 3
            return false
          that.hasChild = false
          angular.forEach(that.value,(v,k)->
            that.hasChild = true
            return false
          )
          return that.hasChild
        
        complete = ()->
          getRootElement()
          hasOwnerChild()

        @toHTML = ()->
          complete()
          switch @type
            when 3,4
              typeObject()
            else 
              typeDefault()
          return @root
        return @
      init = ()->
        iElement.html('')
        html  = ""
        type = objectType(scope.object)
        if type < 3 
          console.error 'the object must be [object]',scope.object
          return ;
        root = new objectHTML(null,scope.object)
        scope.$rootObject = root
        jsonRootElement = root.toHTML().find("span.value:eq(0)").addClass("root").removeClass("value").addClass('type-' + scope.object.constructor.name)
        ele = $compile(jsonRootElement)(scope)
        iElement.append(ele)

      scope.toggle = (event)->
        target =event.target
        #jqite no support parents method
        li = angular.element(target).parent()
        li.toggleClass("selected")
        event.stopPropagation()
        return ;
      if scope.object
        init()
      scope.$watch('object',()->
        init()
      )
  return directiveDefinitionObject
)