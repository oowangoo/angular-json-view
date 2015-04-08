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
###
test
###

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
gulp.task('karma_single',['build_test'],(done)->
  karma.start({
    configFile: __dirname + '/karma.conf.js'
    singleRun:true
  },done)
)
gulp.task('build',['clean','compass','coffee','copy'])
gulp.task('build_test',['build','clean_test','coffee_test'])

gulp.task('bump',['karma_single'],()->
  gulp.src(['./package.json','./bower.json'])
    .pipe(bump({type:'patch'}))
    .pipe(gulp.dest('./'))
)

gulp.task("test",['build_test','watch_test','karma'])
gulp.task('server',['build','watch','connect'])

gulp.task("release",['build_test','bump'])

gulp.task('r',['release'])
gulp.task('s',['server'])