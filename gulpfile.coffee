gulp = require 'gulp'
coffee = require 'gulp-coffee'
compass = require 'gulp-compass'
clean = require "gulp-clean"
plumber = require 'gulp-plumber'
connect = require 'gulp-connect'
gutil = require 'gulp-util'
karma = require('karma').server
bump = require('gulp-bump')
paths = {
  coffee:"src/**/*.coffee"
  compass:"src/**/*.scss"
  html:"src/**/*.html"
  test:
    src:"test/**/*.coffee"
    compile:"test/compile"
}

gulp.task('compass',(done)->
  gulp.src(paths.compass)
    .pipe(plumber())
    .pipe(compass({
      sass:"src"
      css:"www"
    }))
    .on('error',gutil.log)
    .pipe(connect.reload())
)

gulp.task('coffee',(done)->
  gulp.src(paths.coffee)
    .pipe(plumber())
    .pipe(coffee())
    .on('error',gutil.log)
    .pipe(gulp.dest('www/'))
    .pipe(connect.reload())
)



gulp.task('clean',(done)->
  gulp.src('www/**/*',{read:false}).pipe(clean())
)

gulp.task('watch',['build'],(done)->
  gulp.watch(paths.compass,['compass'])
  gulp.watch(paths.coffee,['coffee'])
  gulp.watch(paths.html,['copy'])
)
gulp.task('copy',()->
  gulp.src(paths.html).pipe(gulp.dest('www/')).pipe(connect.reload())
)

gulp.task('reload',()->
  connect.reload()
)
gulp.task('connect',(done)->
  connect.server({
    root:['www','bower_components']
    livereload:true
    port:3000
  })
)

gulp.task('build',['clean','compass','coffee','copy'])
gulp.task('server',['build','watch','connect'])
gulp.task('s',['server'])
####################################
# test task
####################################
gulp.task('coffee_test',['clean_test'],()->
  gulp.src(paths.test.src)
    .pipe(plumber())
    .pipe(coffee())
    .on('error',gutil.log)
    .pipe(gulp.dest(paths.test.compile))
)
gulp.task('clean_test',()->
  gulp.src(paths.test.compile,{read:false}).pipe(clean())
)
gulp.task("watch_test",()->
  gulp.watch(paths.test.src,['coffee_test'])
)
gulp.task('karma',['build_test'],(done)->
  karma.start({
    configFile: __dirname + '/karma.conf.js'
  },done)
)
gulp.task('build_test',['clean_test','build','coffee_test'])
gulp.task("test",['build_test','watch_test','karma'])

####################################
# release task
####################################

gulp.task('karma_single',['build_test','copy_release'],(done)->
  karma.start({
    configFile: __dirname + '/karma.conf.js'
    singleRun:true
    files:['bower_components/jquery/dist/jquery.js','bower_components/angular/angular.js','bower_components/angular-mocks/angular-mocks.js','release/*.js','test/compile/**/*.js']
  },done)
)
gulp.task('copy_release',()->
  gulp.src(["www/json.js","www/style/json.css"])
    .pipe(gulp.dest("release/"))
)
gulp.task('releae_test',['karma_single'])
gulp.task('bump',['karma_single'],()->
  gulp.src(['./package.json','./bower.json'])
    .pipe(bump({type:'patch'}))
    .pipe(gulp.dest('./'))
)



gulp.task("release",['releae_test','bump'])
gulp.task('r',['release'])
