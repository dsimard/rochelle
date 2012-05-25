# mocha --compilers coffee:coffee-script test/*.coffee
require '../node_modules/should'
rochelle = require '../lib'
{inspect, log} = require 'util'
should = require 'should'
cleanCss = require '../node_modules/clean-css'

multipleStyles = ->
  styles = [1..4].map (i)-> "import#{i}.css"          
  styles.push "main.css"
  styles
  
subStyles = ->
  styles = [2..1].map (i)-> "sub#{i}.css"
  styles.push "main.css"
  styles

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
        
    it 'stays in the same order than imports', (done)->
      rochelle.load './test/multiple/main.css', (err, data)->
        should.not.exist err
        data.should.not.include "@import"

        previous = 0

        multipleStyles().forEach (style)->
          data.indexOf(style).should.be.above previous
          previous = data.indexOf(style)
            
        done()

    it 'minifies the css', (done)->
      rochelle.load './test/multiple/main.css', {minify:true}, (err, data)->
        data.ind
      
        previous = 0
        
        multipleStyles().forEach (style)->
          style = style.replace(/\s/, '')
          data.indexOf(style).should.be.above previous
          previous = data.indexOf(style)
            
      done()
    
    it 'loads in sub directories', (done)->
      rochelle.load './test/sub/main.css', (err, data)->
        should.not.exist err
        data.should.not.include "@import"

        previous = 0

        subStyles().forEach (style)->
          data.indexOf(style).should.be.above previous
          previous = data.indexOf(style)
            
        done()
