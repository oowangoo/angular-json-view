(function() {
  angular.module('json.view', ['ng']);

  angular.module('json.view').directive('jsonView', function($compile) {
    var directiveDefinitionObject;
    directiveDefinitionObject = {
      priority: 10,
      restrict: 'E',
      replace: true,
      scope: {
        object: "="
      },
      template: '<div class="json-view"></div>',
      link: function(scope, iElement, iAttrs) {
        var init, objectHTML, objectType;
        objectType = function(obj) {
          if (angular.isNumber(obj)) {
            return 1;
          } else if (angular.isString(obj)) {
            return 2;
          } else if (angular.isArray(obj)) {
            return 3;
          } else if (angular.isObject(obj)) {
            return 4;
          }
          return 0;
        };
        objectHTML = function(name1, value, $parent) {
          var collapser, complete, getPropertyHTML, getRootElement, hasOwnerChild, kuohao, level, span_spilt, that, typeDefault, typeObject;
          this.name = name1;
          this.value = value;
          this.$parent = $parent;
          if (this.$parent) {
            this.$parent.child = this;
            level = this.$parent.getLevel() + 1;
          } else {
            level = 0;
          }
          this.getLevel = function() {
            return level;
          };
          kuohao = [['[', ']'], ['{', '}']];
          this.type = objectType(this.value);
          that = this;
          collapser = "<span class='abs-left collapser' ng-click='toggle($event)'></span>";
          span_spilt = "<span class='spilt'>,</span>";
          getPropertyHTML = function() {
            if (that.name) {
              return "<span class='property'>" + that.name + "</span>: ";
            } else {
              return '';
            }
          };
          getRootElement = function() {
            var li, warp;
            li = angular.element("<li class='type'></li>");
            if (that.value) {
              li.addClass("type-" + that.value.constructor.name);
            }
            warp = angular.element("<div class='content-warp'></div>");
            warp.append(getPropertyHTML());
            li.append(warp);
            that.root = li;
            return that.warp = warp;
          };
          typeDefault = function() {
            return that.warp.append('<span class="value">' + that.value + '</span>');
          };
          typeObject = function() {
            var array, ul, valueSpan;
            valueSpan = angular.element("<span class='value'></span>");
            that.warp.append(valueSpan);
            if (that.hasChild) {
              that.root.addClass("collapsible").append(collapser);
              ul = angular.element("<ul></ul>");
              array = [];
              angular.forEach(that.value, function(v, k) {
                var h, li, name;
                name = k;
                if (that.type === 3) {
                  name = null;
                }
                h = new objectHTML(name, v, that);
                li = h.toHTML();
                return ul.append(li);
              });
              return valueSpan.append(ul);
            }
          };
          hasOwnerChild = function() {
            if (that.type < 3) {
              return false;
            }
            that.hasChild = false;
            angular.forEach(that.value, function(v, k) {
              that.hasChild = true;
              return false;
            });
            return that.hasChild;
          };
          complete = function() {
            getRootElement();
            return hasOwnerChild();
          };
          this.toHTML = function() {
            complete();
            switch (this.type) {
              case 3:
              case 4:
                typeObject();
                break;
              default:
                typeDefault();
            }
            return this.root;
          };
          return this;
        };
        init = function() {
          var ele, html, jsonRootElement, root, type;
          iElement.html('');
          html = "";
          type = objectType(scope.object);
          if (type < 3) {
            console.error('the object must be [object]', scope.object);
            return;
          }
          root = new objectHTML(null, scope.object);
          scope.$rootObject = root;
          jsonRootElement = root.toHTML().find("span.value:eq(0)").addClass("root").removeClass("value").addClass('type-' + scope.object.constructor.name);
          ele = $compile(jsonRootElement)(scope);
          return iElement.append(ele);
        };
        scope.toggle = function(event) {
          var li, target;
          target = event.target;
          li = angular.element(target).parent();
          li.toggleClass("selected");
          event.stopPropagation();
        };
        if (scope.object) {
          init();
        }
        return scope.$watch('object', function() {
          return init();
        });
      }
    };
    return directiveDefinitionObject;
  });

}).call(this);
