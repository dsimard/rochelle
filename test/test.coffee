# mocha -w --compilers coffee:coffee-script test/*.coffee
require '../node_modules/should'
rochelle = require '../lib'
inspect = require('util').inspect
should = require('should')

describe 'Rochelle, Rochelle', ->
  describe 'is simple', ->
    it 'fails when file does not exist', (done)->
      rochelle.load "404.css", (err, data)->
        should.not.exist data
        done()
        
    it 'works', (done)->
      rochelle.load './test/simple/main.css', (err, data)->
        should.exist data
        data.should.not.include '@import'
        done()
