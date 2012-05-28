r = require '../lib'
optimist = require '../node_modules/optimist'
{log, inspect} = require 'util'
path = require 'path'
fs = require 'fs'

# Define the usage
usage = optimist.usage 'Usage: $0 path/to/file.css'
usage.check ->
  throw 'Must pass a filename' if optimist.argv._.length == 0
  
{argv} = usage

# Conver the css
file = argv._[0]
r.load file, (err, data)->
  return console.log err if err?
  
  # Write to a file
  compiledFilename = "_#{path.basename(file)}"
  fs.writeFile path.join(path.dirname(file), compiledFilename), data
