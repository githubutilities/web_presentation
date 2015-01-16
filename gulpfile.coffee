# Load all required libraries
gulp           = require 'gulp'
del            = require 'del'
uglify         = require 'gulp-uglify'
minifyCss      = require 'gulp-minify-css'
runSequence    = require 'run-sequence'
mainBowerFiles = require 'main-bower-files'
rename         = require 'gulp-rename' 
plugins        = require("gulp-load-plugins")(
  pattern: [
    "gulp-*"
    "gulp.*"
    "main-bower-files"
  ]
  replaceString: /\bgulp[\-.]/
)

gulp.task 'copy-libs:js', ->
    gulp.src plugins.mainBowerFiles()
        .pipe plugins.filter('*.js')
        .pipe gulp.dest 'js/'

gulp.task 'copy-libs:css', ->
    gulp.src plugins.mainBowerFiles()
        .pipe plugins.filter('*.css')
        .pipe gulp.dest 'css/'

gulp.task 'minify:js', ->
    gulp.src ['js/*.js', '!js/*.min.js']
        .pipe rename({suffix: '.min'})
        .pipe uglify()
        .pipe gulp.dest 'js/'

gulp.task 'minify:css', ->
    gulp.src ['css/*.css', '!css/*.min.css']
        .pipe rename({suffix: '.min'})
        .pipe minifyCss()   
        .pipe gulp.dest 'css/'

gulp.task 'clean:js', (cb) ->
    del [
        "js/*.js",
        "!js/*.min.js"
    ], cb

gulp.task 'clean:css', (cb) ->
    del [
        "css/*.css",
        "!css/*.min.css"
    ], cb

gulp.task 'copy-libs', ['copy-libs:js', 'copy-libs:css']
gulp.task 'minify', ['minify:js', 'minify:css']
gulp.task 'clean', ['clean:js', 'clean:css']

# Main tasks
gulp.task 'default', -> console.log 'no-op default task'
# gulp.task 'build', runSequence 'copy-libs:js', 'copy-libs:css', 'minify:js', 'minify:css', 'clean:js', 'clean:css'
gulp.task 'build', runSequence 'copy-libs', 'minify', 'clean'