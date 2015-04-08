describe('tttt',()->
  $compile = null
  $rootScope = null

  beforeEach(module('json.view'))
  beforeEach(inject((_$compile_, _$rootScope_)->
    $compile = _$compile_;
    $rootScope = _$rootScope_;
  ))
  getPropertyLength = (object)->
    i = 0;
    angular.forEach(object,(v,k)->
      i++;
    )
    return i;
  
  toEqualElement = (actual,element)->
    checkObj = (obj,ele)->
      l = getPropertyLength(obj)
      return l is $(ele).children("li").length
    checkString = (str,ele)->
      return $(ele).hasClass('type-string')
    equalElement = (obj,ele)->
      r =  checkObj(obj,ele)
      return false unless r 
      index = 0
      children = ele.children("li")
      result = true
      angular.forEach(obj,(v,k)->
        eleRoot = $(children[index])
        index++
        if angular.isObject v 
          eleRoot = eleRoot.children().children("ul") #元素结构为li>div>ul
          r = equalElement(v,eleRoot)
        else if angular.isString(v) or angular.isNumber(v) #eleRoot 为li>span*
          r = checkString(v,eleRoot)
        else 
          r = checkString(v,eleRoot)
        result = false unless r
      )
      return result
    obj = actual
    element = $(element)
    #判断最外层对象类型
    if angular.isObject obj 
      eleRoot = element.find("ul:eq(0)")
      return  equalElement(obj,eleRoot)
    else if angular.isString(v) or angular.isNumber(v)
      return checkString(v,eleRoot)
    else 
      return checkString(v,eleRoot)
  compileElement = (object)->
    $scope = $rootScope.$new()
    $scope.object = object
    element = $compile("<json-view object='object'></json-view>")($scope)
    return element
  it("嵌套object",()->
    sample = {
      name:"value1"
      value:"value2"
      object:{
        name:"1"
        name2:"2"
        object:{
          name:"1"
          ttt:"2"
        }
      }
    }
    element = compileElement(sample)
    expect(toEqualElement(sample,element)).toBeTruthy()
  )
  it("嵌套array",()->
    arr = [
      {name:"1",vvv:'1'}
      {name:"2",vvv:'2'}
      {name:"3",vvv:'3'}
      {name:"4",vvv:[{name:"41",vvv:'42'}]}
    ]
    element = compileElement(arr)
    expect(toEqualElement(arr,element)).toBeTruthy()
  )
  it("混合",()->
    obj = {
      name:"1"
      value:"2"
      array:[{obj:"1",name:"2"},{obj:"21",name:"22"},{obj:"31",name:"32",value:["33.1",'33.2','33.3']}]
      obj:{
        
      }
    }
  )
)