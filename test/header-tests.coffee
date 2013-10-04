chai = require('chai')
expect = chai.expect
sinonChai = require('sinon-chai')
sinon = require('sinon')
prequire = require('proxyquire')
path = require('path')

#extend chai
chai.use sinonChai

#path to use for gulp-header
ghPath = "../lib/header"
ghPath = "../lib-cov/header" if process.env.CODE_COVERAGE is 'true'

describe "Header Class", ->

  #global harness setup
  testFile =
    shortened: 'file.ext'
    base: '/path/'
    path: '/path/file.ext'
    contents: new Buffer('content')

  fsStub = {}

  stubRead = (err, data) ->
    fsStub.readFile = sinon.spy (path, options, callback) ->
      setImmediate -> callback(err, data) #async response

  ms =
    render : (text, options) ->
      return text

  stubRender = (response) ->
    ms.render = sinon.stub().returns(response)

  Header = prequire ghPath,
    'graceful-fs': fsStub
    'mustache' : ms


  #tests
  describe "constructor", ->

    it "will use default options", ->
      #Arrange

      #Act
      h = new Header()

      #Assert
      expect(h._options).to.deep.equal {}
      expect(h._header).to.be.null

    it "will use a string as a header", ->
      #arrange

      #act
      h = new Header('test')

      #assert
      expect(h._options).to.deep.equal {}
      expect(h._header).to.deep.equal new Buffer('test')


    it "will take options as a first parameter", ->
      #arrange
      opts =
        file: path.resolve(__dirname, 'header.txt')

      #act
      h = new Header(opts)

      #assert
      expect(h._header).to.be.null
      expect(h._options).to.deep.equal opts


    it "will take a string as a first parameter and options as a second", ->
      #arrange
      opts =
        file: 'header.txt'

      #act
      h = new Header('test', opts)

      #assert
      expect(h._header).to.deep.equal new Buffer('test')
      expect(h._options).to.deep.equal opts


  describe "mapper", ->

    it "will return an error with no options specified", (next) ->
      #arrange
      h = new Header()

      #act
      h.mapper testFile, (err,file) ->
        #assert
        expect(err).to.be.instanceOf Error
        expect(file).to.be.undefined

        next()


    it "will raise an error from fs.readFile", (next) ->
      #arrange
      expectedError = {}
      stubRead expectedError
      opts =
        file: 'someFile'
      h = new Header opts

      #act
      h.mapper testFile, (err,file) ->
        #assert
        expect(fsStub.readFile).to.be.calledOnce
        expect(fsStub.readFile).to.be.calledWith opts.file, sinon.match.object, sinon.match.func
        expect(err).to.equal expectedError
        expect(file).to.be.undefined
        expect(h._header).to.be.null
        next()


    it "will attempt to read a header from options.file as a path", (next) ->
      #arrange
      expectedResult = 'header'
      stubRead null, expectedResult
      stubRender expectedResult
      opts =
        file: 'someFile'
      h = new Header opts

      #act
      h.mapper testFile, (err,file) ->
        #assert
        expect(fsStub.readFile).to.be.calledOnce
        expect(fsStub.readFile).to.be.calledWith opts.file, sinon.match.object, sinon.match.func
        expect(err).to.be.null
        expect(h._header).to.deep.equal new Buffer('header')
        next()


    it "will prepend the header to the file content", (next) ->
      #arrange
      stubRead null, 'header'
      stubRender 'header'
      opts =
        file: 'someFile'
      h = new Header 'header', opts

      #act
      h.mapper testFile, (err,file) ->
        #assert
        expect(file.contents).to.exist
        expect(file.contents).to.be.instanceOf Buffer
        expect(file.contents).to.deep.equal new Buffer('header\r\ncontent')
        next()


    it "will format the header via mustache", (next) ->
      #arrange
      stubRead null, 'header'
      stubRender 'modified-header'
      opts =
        foo: 'bar'
      h = new Header 'header', opts

      #act
      h.mapper testFile, (err,file) ->
        #assert
        expect(ms.render).to.be.calledOnce
        expect(ms.render).to.be.calledWith 'header', sinon.match.object

        fmtOpts = ms.render.lastCall.args[1]

        expect(fmtOpts.foo).to.equal opts.foo
        expect(fmtOpts.filename).to.equal testFile.shortened
        expect(fmtOpts.now).to.match /^\d\d\d\d\-\d\d\-\d\dT\d\d:\d\d:\d\d(\.\d+)?Z/
        expect(fmtOpts.year).to.equal new Date().getFullYear()

        expect(file.contents).to.deep.equal new Buffer('modified-header\r\ncontent')

        next()
