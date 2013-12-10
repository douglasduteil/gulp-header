# gulp-header

## Usage

```javascript
var header = require('gulp-header');

gulp.src('./foo/*.js')
  .pipe(header('Hello'))
  .pipe(gulp.dest('./dist/')

gulp.src('./foo/*.js')
  .pipe(header('Hello <%= name%>', { name : 'World'} ))
  .pipe(gulp.dest('./dist/')

var pkg = require('./package.json');
var banner = ['/**',
  ' * <%= pkg.name %> - <%= pkg.description %>',
  ' * @version v<%= pkg.version %>',
  ' * @link <%= pkg.homepage %>',
  ' * @license <%= pkg.license %>',
  ' */',
  ''].join('\n');

gulp.src('./foo/*.js')
  .pipe(header(banner, { pkg : pkg } ))
  .pipe(gulp.dest('./dist/')

gulp.src('./foo/*.js')
  .pipe(header.fromFile('banner.js', { pkg : pkg } ))
  .pipe(gulp.dest('./dist/')
```
