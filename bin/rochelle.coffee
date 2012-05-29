r = require '../lib'
optimist = require '../node_modules/optimist'
{log, inspect} = require 'util'
path = require 'path'
fs = require 'fs'

# Define the usage
usage = optimist.usage 'Usage: $0 FILES'
usage.check ->
  throw 'FILES must be defined' if optimist.argv._.length == 0
  
{argv} = usage

# Convert the css
files = argv._

convert = ->
  if files.length > 0
    file = files.pop()
    
    # Convert it
    r.compile file, (err, data)->
      return console.log err if err?
      
      # Write to a file
      compiledFilename = "_#{path.basename(file)}"
      fs.writeFile path.join(path.dirname(file), compiledFilename), data
    
    convert()
    
convert()
    


