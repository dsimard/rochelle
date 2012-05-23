# mocha --compilers coffee:coffee-script test/*.coffee
require '../node_modules/should'
rochelle = require '../lib'
{inspect} = require 'util'
should = require 'should'
cleanCss = require '../node_modules/clean-css'

multiple_styles = ['color: red', 'font-size: 120%', 
  'margin: 1em', 'background-color: cyan',  'font-family: serif']

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
        data.should.include 'content: "main.css"'
        done()
        
    it 'can import multiple css', (done)->
      rochelle.load './test/multiple/main.css', (err, data)->
        should.not.exist err
        data.should.not.include "@import"
        
        multiple_styles.forEach (style)->
            data.should.include style
        
        done()
        
    it 'stays in the same order than imports', (done)->
      rochelle.load './test/multiple/main.css', (err, data)->
        
        previous = 0
        
        multiple_styles.forEach (style)->
            data.indexOf(style).should.be.above previous
            previous = data.indexOf(style)
            
        done()
        
    it 'minifies the css', (done)->
      rochelle.load './test/multiple/main.css', {minify:true}, (err, data)->
        data.ind
      
        previous = 0
        
        multiple_styles.forEach (style)->
          style = style.replace(/\s/, '')
          data.indexOf(style).should.be.above previous
          previous = data.indexOf(style)
            
      done()
      
    it 'loads in sub directories', (done)->
      rochelle.load './test/sub/main.css', (err, data)->
        #data.should.not.include "@import"
        #data.should.include "color: red"
        done()
