chai = require('chai')
expect = chai.expect
sinonChai = require('sinon-chai')
sinon = require('sinon')
prequire = require('proxyquire')
path = require('path')

#extend chai
chai.use sinonChai

#path to use for gulp-header
ghPath = "../lib/gulp-header"
ghPath = "../lib-cov/gulp-header" if process.env.CODE_COVERAGE is 'true'

expected = {}  #result for event-stream .map
expectedBind = -> #result for header .mapper.bind
headerConstructor = sinon.spy() #track header constructor call
esMap = sinon.stub().returns(expected) #stub event-stream .map
headerStub = #header instance for testing
  mapper :
    bind : sinon.stub().returns expectedBind

GulpHeader = prequire ghPath,
  './header': (text,options) ->
    headerConstructor.call(null, arguments)
    return headerStub
  'event-stream':
    map: esMap


describe "gulp-header module", ->
  headerText = "path"
  options =
    option:"test"
  result = GulpHeader headerText, options

  it "should expose a function", ->
    expect(GulpHeader).to.be.instanceOf(Function)
    expect(headerConstructor).to.have.been.calledOnce

  it "should pass headerText argument to Header constructor", ->
    expect(headerConstructor.getCall(0).args[0][0]).to.equal headerText

  it "should pass options argument to Header constructor", ->
    expect(headerConstructor.getCall(0).args[0][1]).to.equal options

  it "should bind the headerStub to the mapper method", ->
    expect(headerStub.mapper.bind).to.have.been.calledOnce
    expect(headerStub.mapper.bind).to.have.been.calledWith headerStub

  it "should pass the instance's mapper method to the event-stream map method", ->
    expect(esMap.calledOnce).to.be.true
    expect(esMap).to.have.been.calledWith expectedBind

  it "should return the results from event-stream map method", ->
    expect(result).to.equal expected
