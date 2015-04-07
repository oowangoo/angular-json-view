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
  $scope.arrayObject = {
    name:"cy"
    email:"cy@fir.im"
    desc:
      url:"fir.im"
      incode:"utf-8"
    apps:[
      {
        name:"app1"
        short:"/app"
      }
      {
        name:"app2"
        short:"/2app"
      }
      {
        name:"app3"
        short:"/3app"
      }
      {
        name:"app4"
        short:"/4app"
      }
    ]
    emptyApps : []
  }
  $http.get("http://fir.im/api/v2/app/info/53ec9b58999aeac87f000c7a").then((data)->
    $scope.object = data
  )
)