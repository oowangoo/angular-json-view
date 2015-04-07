'use strict';

module.exports = function(config) {

  var configuration = {
    autoWatch : true,
    
    base:"./",

    files:['bower_components/jquery/dist/jquery.js','bower_components/angular/angular.js','bower_components/angular-mocks/angular-mocks.js','www/json.js','test/compile/**/*.js'],
    exclude:[],

    frameworks: ['jasmine'],

    port:9876,

    singleRun:false,

    color:true,

    logLevel: config.LOG_DEBUG,
    // ngHtml2JsPreprocessor: {
    //   stripPrefix: 'src/',
    //   moduleName: 'gulpAngular'
    // },

    browsers : ['Chrome'],

    plugins : [
      // 'karma-phantomjs-launcher',
      'karma-chrome-launcher',
      'karma-jasmine'
      // 'karma-ng-html2js-preprocessor'
    ],

    preprocessors: ["progress"]
  };

  config.set(configuration);
};
