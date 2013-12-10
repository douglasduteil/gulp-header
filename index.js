'use strict';

var path = require('path');
var fs = require('fs');

var es = require('event-stream');
var gutil = require('gulp-util');
var extend = require('lodash.assign');

var headerPlugin = function(headerText, options) {
  var txt = headerText || '';
  return es.map(function(file, cb){
    file.contents = Buffer.concat([new Buffer(gutil.template(txt, extend({file : file}, options))), file.contents]);
    cb(null, file);
  });
};

headerPlugin.fromFile = function (filepath, options){
  var fileContent = fs.readFileSync(path.resolve(process.cwd(), filepath));
  return headerPlugin(fileContent, options);
};

module.exports = headerPlugin;
