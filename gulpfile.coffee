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

# source code destination
srcDest     = "src/"
jsSelector  = [srcDest + 'js/*.js', '!' + srcDest + 'js/*.min.js']
cssSelector = [srcDest + 'css/*.css', '!' + srcDest + 'css/*.min.css']
destDest    =  "dist/"

gulp.task 'copy-libs:js', ->
    gulp.src plugins.mainBowerFiles()
        .pipe plugins.filter('*.js')
        .pipe gulp.dest srcDest + 'js/'

gulp.task 'copy-libs:css', ->
    gulp.src plugins.mainBowerFiles()
        .pipe plugins.filter('*.css')
        .pipe gulp.dest srcDest + 'css/'

gulp.task 'minify:js', ->
    gulp.src jsSelector
        .pipe rename({suffix: '.min'})
        .pipe uglify()
        .pipe gulp.dest srcDest + 'js/'

gulp.task 'minify:css', ->
    gulp.src cssSelector
        .pipe rename({suffix: '.min'})
        .pipe minifyCss()   
        .pipe gulp.dest srcDest + 'css/'

gulp.task 'release', ->
    gulp.src [srcDest + '**/*']
        .pipe gulp.dest destDest

gulp.task 'clean:js', (cb) ->
    del jsSelector, cb

gulp.task 'clean:css', (cb) ->
    del cssSelector, cb

gulp.task 'clean:all', (cb) ->
    del [
        srcDest + "js/",
        srcDest + "css/"
    ], cb

gulp.task 'copy-libs', ['copy-libs:js', 'copy-libs:css']
gulp.task 'minify', ['minify:js', 'minify:css']
gulp.task 'clean', ['clean:js', 'clean:css']

# Main tasks
gulp.task 'default', -> console.log 'no-op default task'
# gulp.task 'build', runSequence 'copy-libs:js', 'copy-libs:css', 'minify:js', 'minify:css', 'clean:js', 'clean:css'
gulp.task 'build', -> runSequence 'copy-libs', 'minify', 'clean'