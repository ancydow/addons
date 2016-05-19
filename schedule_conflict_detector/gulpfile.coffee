gulp = require('gulp')

gutil = require('gulp-util')
transform = require('vinyl-transform')
source = require('vinyl-source-stream')
changeExtension = require('gulp-ext-replace')
es = require('event-stream')
concat = require('gulp-concat')

coffee = require('gulp-coffee')
handlebars = require('hbsfy')
sass = require('gulp-sass')
browserify = require('browserify')
jasmine = require('gulp-jasmine')

gulp.task 'coffeescript', ->
  gulp.src('./src/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./build/'))

gulp.task 'handlebars', ->
  handlebarred = transform (filename)->
    handlebars(filename)

  gulp.src('./src/**/*.hbs')
    .pipe(handlebarred)
    .pipe(changeExtension('.js'))
    .pipe(gulp.dest('./build/'))

gulp.task 'sass', ->
  files = gulp.src('./src/**/*.scss')
    .pipe(sass(outputStyle: 'compressed'))
  es.concat(files)
    .pipe(concat('app.css'))
    .pipe(gulp.dest('./public'))

gulp.task 'browserify', ['coffeescript', 'handlebars'], ->
  browserify(entries: ['./build/index.js'])
    .bundle()
    .pipe(source('./index.js'))
    .pipe(gulp.dest('./public/'))

gulp.task 'build', ['sass', 'browserify']

gulp.task 'specs', ->
  gulp.src('specs/**/*_spec.coffee')
    .pipe(jasmine(includeStackTrace: true))


gulp.task 'watch', ->
  gulp.watch('./src/**/*.coffee', ['coffeescript', 'browserify'])
  gulp.watch('./src/**/*.hbs', ['handlebars', 'browserify'])
  gulp.watch('./src/**/*.scss', ['sass', 'browserify'])
