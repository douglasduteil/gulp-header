//global variables
var es = require('event-stream')
  ,fs = require('graceful-fs')
  ,path = require('path')
  ,clone = require('clone')
  ,extend = require('xtend')
  ,Mustache = require('mustache')
  ,EventEmitter = require('events').EventEmitter;
;

module.exports = Header;
Header.prototype.mapper = mapper;
Header.prototype._getHeaderText = getHeaderText;
Header.prototype._startRead = startRead;

//Module constructor
function Header(headerText, options) {
  //passed in options directly, no headerText
  //shift params out
  if (typeof headerText !== "string" && typeof options === "undefined") {
    options = headerText;
    headerText = null;
  }

  this._header = headerText ? new Buffer(headerText + "\r\n") : null;
  this._options = extend({}, clone(options));
  this._emitter = null;
}


//Header.prototype.mapper - EventStream mapper function for adding a header to a file
function mapper(file, cb) {
  //get headerText
  this._getHeaderText(function(err,headerText) {
    //unable to get header text
    if (err) return cb(err);

    //add filename, now and year to the options for formatting
    var fmtOptions = extend({}, this._options, { filename:file.shortened, now:new Date(), year: new Date().getFullYear() })

    var newFile = clone(file);
    newFile.contents = new Buffer(Mustache.render(headerText, options) + newFile.contents);
    return cb(null,newFile);
  });
}


//Header.prototype._getHeaderText - gets the header text for the module instance
function getHeaderText(callback) {
  //already have the header text, use it
  if (this._header) return callback(null, this._header);

  //has options for a file
  if (this._options && h._options.file) {
    //init read process, bind events for callback
    return (this._emitter || this._startRead()).on('error', callback).on('text', callback.bind(null,null));
  }

  return callback(new Error("No headerText or file option specified."));
}

//Header.prototype._startRead()
function startRead() {
  fs.readFile(this._options.file, {encoding:'utf8'}, function(err, contents) {
    //cleanup emitter
    var em = this._emitter; //reference to original emitter
    this._emitter = null; //cleanup object handler

    //error reading file
    if (err) return em.emit('error', err);

    //read file, assign value to buffer, and emit the text event
    this._header = new Buffer(contents + "\r\n"); //save reference
    em.emit('text', headerText); //emit text event
  });

  return this._emitter = new EventEmitter();
}