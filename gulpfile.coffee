gulp = require 'gulp'
jsc = require 'jscoverage'
cp = require 'child_process'
fs = require 'fs'
path = require 'path'
open = require 'open'
rimraf = require 'rimraf'

gulp.task 'test', ->
  process.env.CODE_COVERAGE = 'false'
  cp.fork(
    'node_modules/mocha/bin/mocha',
    ['-R','spec','-u','bdd','--compilers','coffee:coffee-script','--require','chai',path.resolve(__dirname,'./test/')]
  )

gulp.task 'functional', ->
  console.log "Running functional tests..."
  cp.fork(
    'node_modules/mocha/bin/mocha',
    ['-R','spec','-u','bdd','--compilers','coffee:coffee-script','--require','chai',path.resolve(__dirname,'./test/functional/')]
  )

gulp.task 'coverage', ->
  codecoverage = process.env.CODE_COVERAGE
  process.env.CODE_COVERAGE = 'true'

  console.log 'Clearing previous lib-cov directory...'
  rimraf './lib-cov', (err) ->
    if err
      return console.log(err)

    console.log 'Generate coverage library...'
    jsc.processFile './lib','./lib-cov', null, null

  console.log 'Running tests...'
  cp.execFile(
    'node',
    ['node_modules/mocha/bin/mocha','-R','html-cov','-u','bdd','--compilers','coffee:coffee-script','--require','chai',path.resolve(__dirname,'./test/')],
    {},
    (error, stdout, stderr) ->
      console.log 'Saving coverage results...'
      fs.createWriteStream('./lib-cov/coverage.html').write(stdout)
      openCoverageDocumentInBrowser()
      process.env.CODE_COVERAGE = codecoverage || 'false'
      console.warn '\r\nComplete' #console.warn will flush the output
      process.exit error?.code? or 0
  )

openCoverageDocumentInBrowser = ->
  console.log 'Opening coverage results...'
  url = 'file:///' + path.resolve(__dirname, './lib-cov/coverage.html').replace(/\\/g,'/')
  open url.replace('file:////','file:///')