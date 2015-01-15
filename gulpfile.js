// Include gulp
var gulp      = require('gulp');
var rename    = require( 'gulp-rename' );
var uglify    = require( 'gulp-uglify' );
var minifyCss = require('gulp-minify-css');
var usemin    = require('gulp-usemin');
var del       = require('del');

 //Include plugins
 var plugins = require("gulp-load-plugins")({
	pattern: ['gulp-*', 'gulp.*', 'main-bower-files'],
	replaceString: /\bgulp[\-.]/
 });

gulp.task('js_minify', function() {
	// Define default destination folder
	var dest = 'js/';

	var files = [
        'js/*.js',
        '!js/*.min.js'
    ];

    // moving the js files
	gulp.src( plugins.mainBowerFiles() )
		.pipe( plugins.filter('*.js') )
		.pipe( gulp.dest( dest ) );

	// minify the js files and rename it
    var stream = gulp.src( files )
		.pipe( rename({suffix: '.min'}) )
		.pipe( uglify() )
		.pipe( gulp.dest( dest ) );

	
// var jsFiles = ['src/js/*'];
// gulp.src(plugins.mainBowerFiles().concat(jsFiles))
//		.pipe(plugins.filter('*.js'))
//		.pipe(plugins.concat('main.js'))
//		.pipe(plugins.uglify())
//		.pipe(gulp.dest(dest + 'js'));

 });

gulp.task('clean', function( cb ) {
	var files = [
        'js/*.js',
        '!js/*.min.js'
    ];
    del(files, cb);
});

gulp.task('css', function() {
	// Define default destination folder
	var dest = 'css/';
	gulp.src(plugins.mainBowerFiles())
		.pipe(plugins.filter('*.css'))
		//.pipe(/* doing something with the JS scripts */)
		.pipe(gulp.dest(dest));
 });

// gulp.task('build', function() {
//	gulp.src('templates/layout.src.tpl')
//			.pipe(usemin({
//				assetsDir: 'public',
//				css: [minifyCss(), 'concat'],
//				js: [uglify(), 'concat']
//			}))
//			.pipe(gulp.dest('public'));
//});



// Default Task
gulp.task('default', ['js_minify','css']);