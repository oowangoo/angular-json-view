# Registers a new directive with the compiler
#
angular.module('json.View').directive('jsonView', () ->
  directiveDefinitionObject =
    priority: 10
    restrict: 'E'
    template: 'HTML'
    link: (scope, iElement, iAttrs) ->
      return ;
    
  return directiveDefinitionObject
)