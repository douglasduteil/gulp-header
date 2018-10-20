/* jshint node: true */
'use strict';

var path = require('path');
var fs = require('fs');

var es = require('event-stream');
var template = require('lodash.template');
var extend = require('lodash.assign');

var headerPlugin = function(headerText, data) {
  headerText = headerText || '';
  
  return es.map(function(file, callback){
    var templateFunction = template(headerText);
    var headerWithContent = templateFunction(extend({file: file}, data));
    
    file.contents = Buffer.concat([
      new Buffer(headerWithContent),
      file.contents
    ]);
    callback(null, file);
  });
};

headerPlugin.fromFile = function (filepath, data){
  if ('string' !== typeof filepath) throw new Error('Invalid filepath');
  var fileContent = fs.readFileSync(path.resolve(process.cwd(), filepath));
  return headerPlugin(fileContent, data);
};

module.exports = headerPlugin;
