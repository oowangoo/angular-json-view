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
        else if angular.isNumber(obj)
          return 3
        else if angular.isString(obj) 
          return 4;
        return 0

      objectHTML = (@name,@value,@$parent)->
        if @$parent
          @$parent.child = @
        kuohao = [
          ['[',']']
          ['{','}']
        ]

        @type = objectType(@value)
        that = @
        #折叠对象        
        collapser = "<span class='abs-left collapser' ng-click='toggle($event)'></span>"
        span_spilt = "<span class='spilt'>,</span>"
        getPropertyHTML = ()->
          if that.name 
            "<span class='property'>#{that.name}</span>: "
          else 
            ''
        getRootElement = ()->
          if that.$parent
            li = angular.element("<li class='type'></li>")
          else 
            li = angular.element("<div></div>")
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
          that.warp.append("<span class='before-cls'>#{kuohao[that.type - 1][0]}</span>")

          if that.hasChild
            that.root.addClass("collapsible")
            that.warp.append(collapser)
            ul = angular.element("<ul></ul>")
            array = []
            angular.forEach(that.value,(v,k)->
              name = k
              if that.type is 1
                name = null
              h = new objectHTML(name,v,that)
              li = h.toHTML()
              wp = li.children()
              wp.append(span_spilt)
              array.push li
            )
            if array.length > 0
              last = array[array.length - 1]
              # last.find('span.spilt').remove()  #会删除子集下的
              cl = last.children().children() #li>div>span.name+span.value...
              angular.element(cl[cl.length - 1 ]).remove() #最后一个元素，
            for ai in array
              ul.append(ai)
            that.warp.append(ul)
            that.warp.append("<span class='ellipsis'>...</span>")
          that.warp.append("<span class='after-cls'>#{kuohao[that.type - 1][1]}</span>")

        hasOwnerChild = ()->
          if that.type > 2
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
            when 1,2
              typeObject()
            else 
              typeDefault()
          return @root
        return @
      init = ()->
        iElement.html('')
        html  = ""
        type = objectType(scope.object)
        if type > 2
          console.error 'the object must be [object]',scope.object
          return ;
        root = new objectHTML(null,scope.object)
        scope.$rootObject = root

        ele = $compile(root.toHTML())(scope)
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