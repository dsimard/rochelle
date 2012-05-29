# mocha --compilers coffee:coffee-script
require '../node_modules/should'
rochelle = require '../lib'
{inspect, log} = require 'util'
should = require 'should'
cleanCss = require '../node_modules/clean-css'
{exec, spawn} = require 'child_process'
fs = require 'fs'
path = require 'path'
helper = require './helper'


describe 'Rochelle, Rochelle', ->
  describe 'is simple', ->
    it 'fails when file does not exist', (done)->
      rochelle.compile "404.css", (err, data)->
        should.exist err
        should.not.exist data
        done()
        
    it 'works', (done)->
      rochelle.compile './examples/simple/main.css', (err, data)->
        should.not.exist err
        should.exist data
        data.should.not.include "@import 'imported.css';"
        data.should.include 'content: "main.css"'
        done()
        
    it 'stays in the same order than imports', (done)->
      rochelle.compile './examples/multiple/main.css', (err, data)->
        should.not.exist err
        data.should.not.include "@import"

        previous = 0

        helper.multipleStyles().forEach (style)->
          data.indexOf(style).should.be.above previous
          previous = data.indexOf(style)
            
        done()

    it 'minifies the css', (done)->
      rochelle.compile './examples/multiple/main.css', {minify:true}, (err, data)->
        data.indexOf("\n").should.eql -1
        done()
    
    it 'loads in sub directories', (done)->
      rochelle.compile './examples/sub/main.css', (err, data)->
        should.not.exist err
        data.should.not.include "@import"

        previous = 0

        helper.subStyles().forEach (style)->
          data.indexOf(style).should.be.above previous
          previous = data.indexOf(style)
            
        done()
        
describe 'Rochelle command line', ->
  afterEach (done)->
    mainFiles = helper._mainFiles()
    unlink = (callback)-> 
      if mainFiles.length > 0
        fs.unlink mainFiles.pop(), ->
          unlink()
      else
        done()
        
    unlink()
  
  describe 'simple', ->
    it "throws an error when no file", (done)->
      exec "coffee bin/rochelle.coffee", (error, stdout, stderr)->
        should.exist error
        stderr.should.include 'FILES must be defined'
        done()
        
    it "works", (done)->
      exec "coffee bin/rochelle.coffee examples/simple/main.css", (err, stdout, stderr)->
        path.exists "examples/simple/_main.css", (exists)->
          exists.should.be.ok
          
          # open the file to see if everything is ok
          fs.readFile "examples/simple/_main.css", 'utf8', (err, data)->
            data.should.not.include "@import 'imported.css';"
            data.should.include 'content: "main.css"'
            
            done()
            
    it "works with many files", (done)->
      exec "coffee bin/rochelle.coffee #{helper.mainFiles().join(" ")}", (err, stdout, stderr)->
        mainFiles = helper._mainFiles()
        check = ->
          if mainFiles.length > 0
            path.exists mainFiles.pop(), (exists)->
              exists.should.be.ok
            check()
          else
            done()
        
        check()
        
    it "skip a files that doesn't exist", (done)->
      mainFiles = helper._mainFiles().concat(["404.css"])
      exec "coffee bin/rochelle.coffee #{helper.mainFiles().join(" ")}", (err, stdout, stderr)->
        check = ->
          if mainFiles.length > 0
            file = mainFiles.pop()
            path.exists file, (exists)->
              if file == "404.css"
                exists.should.not.be.ok
              else
                exists.should.be.ok
            check()
          else
            done()
        
        check()
         
