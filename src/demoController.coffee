angular.module("json.view").controller("demoCtrl",($scope,$http)->
  $scope.object = {
    name:"cy"
    email:"cy@fir.im"
    desc:
      url:"fir.im"
      incode:"utr-8"
    emptyObj:{}
    xxx:null
  }
  $scope.arrayObject = [
      {name:"1",vvv:'1'}
      {name:"2",vvv:'2'}
      {name:"3",vvv:'3'}
      {name:"4",vvv:[{name:"41",vvv:'42'}]}]
)