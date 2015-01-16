// Include gulp
var gulp        = require('gulp');
var rename      = require( 'gulp-rename' );
var uglify      = require( 'gulp-uglify' );
var minifyCss   = require('gulp-minify-css');
var usemin      = require('gulp-usemin');
var del         = require('del');
var runSequence = require('run-sequence');
var rm          = require('gulp-rimraf');
var Q           = require('q');
var concat      = require('gulp-concat');

// Include plugins
 var plugins = require("gulp-load-plugins")({
	pattern: ['gulp-*', 'gulp.*', 'main-bower-files'],
	replaceString: /\bgulp[\-.]/
 });

gulp.task('js_minify', function() {
	// Define default destination folder
	//console.log('js start');
	var deferred = Q.defer();
	var dest = 'js/';
	//gulp.src( dest , { buffer: false }).pipe(rm());

	var files = [
        'js/*.js',
        '!js/*.min.js'
    ];

    // moving the js files
	gulp.src( plugins.mainBowerFiles() )
		.pipe( plugins.filter('*.js') )
		.pipe( gulp.dest( dest ) );

	// minify the js files and rename it
	gulp.src( files )
		.pipe( rename({suffix: '.min'}) )
		.pipe( uglify() )
		.pipe( gulp.dest( dest ) );

	gulp.src( 'js/*.min.js' )
		.pipe( concat( 'main.js' ) )
		.pipe( uglify() )
		.pipe( gulp.dest( dest ) );

// var jsFiles = ['src/js/*'];
// gulp.src(plugins.mainBowerFiles().concat(jsFiles))
//		.pipe(plugins.filter('*.js'))
//		.pipe(plugins.concat('main.js'))
//		.pipe(plugins.uglify())
//		.pipe(gulp.dest(dest + 'js'));
	//console.log('js_stop');
	deferred.resolve();
	return deferred.promise;
 });

gulp.task('clean', function() {
	//console.log('clean start');
	var deferred = Q.defer();
	var dest = 'js/';
	var files = [
        'js/*.js',
        '!js/*.min.js'
    ];
	gulp.src(files)
		.pipe(rm());
	//console.log('clean stop');
	//callback(err);
	deferred.resolve();
	return deferred.promise;
});

gulp.task('css', function() {
	var deferred = Q.defer();
	//console.log('css start');
	// Define default destination folder
	var dest = 'css/';
	gulp.src(plugins.mainBowerFiles())
				.pipe(plugins.filter('*.css'))
				.pipe(gulp.dest(dest));
	var files = [
		'css/*.css',
		'!css/*.min.css'
	];
	gulp.src( files )
		.pipe( rename({suffix: '.min'}) )
		.pipe(minifyCss())
		.pipe( gulp.dest( dest ) );

	//console.log('css stop');
	deferred.resolve();
	return deferred.promise;
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


gulp.task('build', function(callback) {

	runSequence(['js_minify','css'],
		'clean',
		callback);
});

// Default Task
gulp.task('default', ['build']);