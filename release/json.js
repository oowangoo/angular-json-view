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
          if (angular.isArray(obj)) {
            return 1;
          } else if (angular.isObject(obj)) {
            return 2;
          } else if (angular.isNumber(obj)) {
            return 3;
          } else if (angular.isString(obj)) {
            return 4;
          }
          return 0;
        };
        objectHTML = function(name1, value, $parent) {
          var collapser, complete, getPropertyHTML, getRootElement, hasOwnerChild, kuohao, span_spilt, that, typeDefault, typeObject;
          this.name = name1;
          this.value = value;
          this.$parent = $parent;
          if (this.$parent) {
            this.$parent.child = this;
          }
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
            if (that.$parent) {
              li = angular.element("<li class='type'></li>");
            } else {
              li = angular.element("<div></div>");
            }
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
            var ai, array, cl, i, last, len, ul;
            that.warp.append("<span class='before-cls'>" + kuohao[that.type - 1][0] + "</span>");
            if (that.hasChild) {
              that.root.addClass("collapsible");
              that.warp.append(collapser);
              ul = angular.element("<ul></ul>");
              array = [];
              angular.forEach(that.value, function(v, k) {
                var h, li, name, wp;
                name = k;
                if (that.type === 1) {
                  name = null;
                }
                h = new objectHTML(name, v, that);
                li = h.toHTML();
                wp = li.children();
                wp.append(span_spilt);
                return array.push(li);
              });
              if (array.length > 0) {
                last = array[array.length - 1];
                cl = last.children().children();
                angular.element(cl[cl.length - 1]).remove();
              }
              for (i = 0, len = array.length; i < len; i++) {
                ai = array[i];
                ul.append(ai);
              }
              that.warp.append(ul);
              that.warp.append("<span class='ellipsis'>...</span>");
            }
            return that.warp.append("<span class='after-cls'>" + kuohao[that.type - 1][1] + "</span>");
          };
          hasOwnerChild = function() {
            if (that.type > 2) {
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
              case 1:
              case 2:
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
          var ele, html, root, type;
          iElement.html('');
          html = "";
          type = objectType(scope.object);
          if (type > 2 || type === 0) {
            console.error('the object must be [object]', scope.object);
            return;
          }
          root = new objectHTML(null, scope.object);
          scope.$rootObject = root;
          ele = $compile(root.toHTML())(scope);
          return iElement.append(ele);
        };
        scope.toggle = function(event) {
          var li, target;
          target = event.target;
          li = angular.element(target).parent().parent();
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
