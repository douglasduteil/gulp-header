gulp-header
===========

[![Build Status](https://travis-ci.org/godaddy/gulp-header.png)](https://travis-ci.org/godaddy/gulp-header)

Gulp extension to add a header to file(s) in the pipeline

    var header = require('gulp-header');

Structure
---------

* `header` = function([headerText], [options])
  * `headerText` string optional
    * The text to use for the header to be prepended to the files in the stream.
    * Will be formatted against the mustache processor, and passed an options object with the following fields added
      * `filename` - the name of the file being added
      * `now` - ISO-8601 formatted datetime
      * `year` - the current year
  * `options` object optional
    * `file` string optional
      * a file to use for the headerText, if headerText isn't specified
    * other parameters will be passed through to the markdown processor against `headerText`

Example
-------
    var header = require('gulp-header');
    var gc = require('gulp-concat');
    //header = function([headerText], [options]);
    
    ...headerText from string...
    var headerText = '' +
        '/*! {{filename}} - '+
        'Copyright {{year}} MyCompany - '+
        'MIT License - '+
        'generated {{now}} - {{foo}} */'+
        '';
    gulp.src('./lib/*.js')
        .pipe(gc('merged.js'))
        .pipe(header(headerText, {foo:'bar'}))
        .pipe(gulp.dest('./dist/')
    
    ...options - headerText from file...
    gulp.src('./lib/*.js')
        .pipe(gc('merged.js'))
        .pipe(header({
            file:__dirname + '/text/header.txt'
            ,foo:'bar'
        }))
        .pipe(gulp.dest('./dist/')

Testing
-------

Unit Tests

    npm test

Code Coverage

    npm run-script coverage


License
-------

    The MIT License (MIT)

    Copyright (c) 2013 GoDaddy.com

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
