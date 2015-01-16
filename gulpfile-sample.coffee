# Load all required libraries
gulp = require 'gulp'
del = require 'del'
coffee = require 'gulp-coffee'
less = require 'gulp-less'
changed = require 'gulp-changed'
uglify = require 'gulp-uglify'
cssmin = require 'gulp-minify-css'
htmlmin = require 'gulp-htmlmin'
size = require 'gulp-filesize'
runSequence = require 'run-sequence'
merge = require 'merge-stream'

typeIsArray = Array.isArray || ( value ) -> return {}.toString.call( value ) is '[object Array]'
bower = (value) -> # prefix the given path/array with the bower directory
    if !typeIsArray value then "bower_components/" + value else value.map (str) -> bower str

gulp.task 'clean:development', (cb) ->
    del [
        "src/js/*.js", "!src/js/data.js" # in development, delete all .js files except data.js
        "src/css/main.css", "src/css/sidebar.css", "src/css/bootstrap*"
        "src/fonts/"
        "src/js/libs/"
    ], cb

gulp.task 'clean:dist', (cb) ->
    del "build/", cb

gulp.task 'coffee', ->
    gulp.src "src/js/main.coffee"
        .pipe coffee()
        .pipe gulp.dest "src/js"

gulp.task 'less', ->
    gulp.src "src/css/main.less"
        .pipe less()
        .pipe gulp.dest "src/css"

gulp.task 'copy-libs:development', -> # install and copy only the required bower files to the right directory (under src/)
    merge( # here we have to merge the streams otherwise only the latest one will be returned
        gulp.src bower [
                "jquery/dist/*",
                "angular/angular*.{js,js.map}"
                "angular-sanitize/*.{js,js.map}"
                "angular-animate/*.{js,js.map}"
                "bootstrap/dist/js/*"]
            .pipe changed "src/js/libs"
            .pipe gulp.dest "src/js/libs"
        gulp.src bower "bootstrap/dist/fonts/*"
            .pipe changed "src/fonts"
            .pipe gulp.dest "src/fonts"
        gulp.src bower ["bootstrap/dist/css/bootstrap.css*", "bootstrap/dist/css/bootstrap.min.css"]
            .pipe changed "src/css"
            .pipe gulp.dest "src/css"
    )

gulp.task 'watch', ->
    gulp.watch "src/js/main.coffee", ['coffee']
    gulp.watch "src/css/main.less", ['less']

gulp.task 'minify', ['coffee', 'less'], ->
    merge(
        gulp.src "src/js/main.js"
            .pipe uglify()
            .pipe gulp.dest "build/js"
        gulp.src "src/css/main.css"
            .pipe cssmin()
            .pipe gulp.dest "build/css"
        gulp.src "src/index.html"
            .pipe htmlmin {collapseWhitespace: true, removeComments: true}
            .pipe gulp.dest "build"
    )

gulp.task 'copy-libs:dist', ['copy-libs:development'], ->
    # the 'base' option here is used to keep the structure under the src/ directory (otherwise it is flattened)
    gulp.src ["js/data.js", "js/libs/*", "fonts/*", "css/bootstrap.min.css"], {cwd: "src", base: "src"}
        .pipe size()
        .pipe gulp.dest "build"


# Main tasks
gulp.task 'default', -> console.log 'no-op default task'
gulp.task 'clean', ['clean:development', 'clean:dist']
gulp.task 'development', -> runSequence 'clean:development', ['copy-libs:development', 'coffee', 'less', 'watch']
gulp.task 'dist', -> runSequence 'clean:dist', ['copy-libs:dist', 'minify']