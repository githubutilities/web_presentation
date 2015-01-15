// Include gulp
var gulp = require('gulp');
var rename     = require( 'gulp-rename' );
var uglify     = require( 'gulp-uglify' );


 //Include plugins
 var plugins = require("gulp-load-plugins")({
	pattern: ['gulp-*', 'gulp.*', 'main-bower-files'],
	replaceString: /\bgulp[\-.]/
 });


gulp.task('js', function() {
	// Define default destination folder
	var dest = 'js/';
	gulp.src(plugins.mainBowerFiles())
		.pipe(plugins.filter('*.js'))
		.pipe(gulp.dest(dest));

	// minify scrollReveal.js
	gulp.src( 'js/scrollReveal.js' )
		.pipe( rename( 'scrollReveal.min.js' ) )
		.pipe( uglify() )
		.pipe( gulp.dest( dest ) );
	gulp.src( 'js/jquery.fullPage.js' )
		.pipe( rename( 'jquery.fullPage.min.js' ) )
		.pipe( uglify() )
		.pipe( gulp.dest( dest ) );
// var jsFiles = ['src/js/*'];
// gulp.src(plugins.mainBowerFiles().concat(jsFiles))
//		.pipe(plugins.filter('*.js'))
//		.pipe(plugins.concat('main.js'))
//		.pipe(plugins.uglify())
//		.pipe(gulp.dest(dest + 'js'));
 });

gulp.task('css', function() {
	// Define default destination folder
	var dest = 'css/';
	gulp.src(plugins.mainBowerFiles())
		.pipe(plugins.filter('*.css'))
		//.pipe(/* doing something with the JS scripts */)
		.pipe(gulp.dest(dest));
 });

gulp.task('build', function() {
	gulp.src('templates/layout.src.tpl')
			.pipe(usemin({
				assetsDir: 'public',
				css: [minifyCss(), 'concat'],
				js: [uglify(), 'concat']
			}))
			.pipe(gulp.dest('public'));
});

// Default Task
gulp.task('default', ['js','css']);