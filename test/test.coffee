# mocha -w --compilers coffee:coffee-script test/*.coffee
require '../node_modules/should'
rochelle = require '../lib'
{inspect} = require 'util'
should = require('should')

describe 'Rochelle, Rochelle', ->
  describe 'is simple', ->
    it 'fails when file does not exist', (done)->
      rochelle.load "404.css", (err, data)->
        should.exist err
        should.not.exist data
        done()
        
    it 'works', (done)->
      rochelle.load './test/simple/main.css', (err, data)->
        should.not.exist err
        should.exist data
        data.should.not.include "@import 'imported.css';"
        data.should.include "color: blue;"
        done()
        
    it 'can import multiple css', (done)->
      rochelle.load './test/multiple/main.css', (err, data)->
        should.not.exist err
        data.should.not.include "@import"
        
        ['color: red;', 'font-size: 120%', 
          'margin: 1em;', 'background-color: cyan;'].forEach (style)->
            data.should.include style
        
        done()
