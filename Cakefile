{exec} = require 'child_process'
fs = require 'fs'

task 'doc', 'Regenerate doc', (options)->
  exec 'docco-husky lib/ bin/', (err, stdout, stderr)->
    return console.log err if err?
    console.log stdout
    
    #exec 'cd docs && git commit -am "Doc regenerated automatically" && cd ..', (err, stdout, stderr)->
    #  return console.log stderr if err?
      
      
task 'build', 'build scripts to be compatible with js', ->
  exec 'coffee -c -o bin/ bin/rochelle.coffee', (err)->
    return console.log err if err?
  
    exec "echo '#!/usr/bin/env node' | cat - bin/rochelle.js > bin/rochelle.tmp && mv bin/rochelle.tmp bin/rochelle.js", ->
      exec 'coffee -c -o lib lib'
      
task 'clean', 'Remove all js files', ->
  fs.unlink 'bin/rochelle.js', ->
    fs.unlink 'lib/index.js'

