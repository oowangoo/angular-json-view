gulp = require 'gulp'
coffee = require 'gulp-coffee'
compass = require 'gulp-compass'
clean = require "gulp-clean"
plumber = require 'gulp-plumber'
connect = require 'gulp-connect'
gutil = require 'gulp-util'

paths = {
  coffee:"src/**/*.coffee"
  compass:"src/**/*.scss"
  html:"src/**/*.html"
}

gulp.task('compass',(done)->
  gulp.src("src/**/*.scss")
    .pipe(compass({
      sass:"src"
      css:"www"
    }))
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

gulp.task('watch',(done)->
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