# mocha -Gw --compilers coffee:coffee-script test/*
require '../node_modules/should'
describe 'Number', ->
  describe 'o', ->
    it 'works', (done)->
      "test".should.equal "test"
      done()
