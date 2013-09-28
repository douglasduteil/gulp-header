//global variables
var es = require('event-stream')
  ,Header = require('./header');

//Exports
module.exports = function(headerText, options) {
  var hm = new Header(headerText, options);
  return es.map(hm.mapper.bind(hm));
};
