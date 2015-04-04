gulp = require 'gulp'
coffee = require 'gulp-coffee'
sass = require 'gulp-sass'
clean = require "gulp-clean"
plumber = require 'gulp-plumber'
connect = require 'gulp-connect'
paths = {
  coffee:"src/**/*.coffee"
  sass:"src/**/*.scss"
  html:"src/**/*.html"
}

gulp.task('sass',(done)->
  gulp.src(paths.sass)
    .pipe(plumber())
    .pipe(sass())
    .pipe(gulp.dest('www/'))
)

gulp.task('coffee',(done)->
  gulp.src(paths.coffee)
    .pipe(plumber())
    .pipe(coffee())
    .pipe(gulp.dest('www/'))
)

gulp.task('clean',(done)->
  gulp.src('www/',{read:false}).pipe(clean())
)

gulp.task('watch',(done)->
  gulp.watch(paths.sass,['sass','reload'])
  gulp.watch(paths.coffee,['coffee','reload'])
)

gulp.task('copy',(done)->
  gulp.src(paths.html,{read:false}).pipe(gulp.dest('www/'))
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


gulp.task('build',['clean','sass','coffee','copy'])
