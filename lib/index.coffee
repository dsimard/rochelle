fs = require 'fs'
path = require 'path'
{log} = require 'util'
{inspect} = require 'util'

r = 
  # Regexp to match an import line
  IMPORT : /\@import[^;$]+;*/ig
  
  # Load the main file and aggregate files specified by _@import_
  #
  # `file` is the complete file path
  #
  # Callback has two argument. `err` and `data` which contains the aggregated css
  load : (file, callback)->
    fs.realpath file, (err, resolved)->
      return callback(err) if err
      
      fs.readFile resolved, 'utf8', (err, data)->
        return callback(err) if err
        
        # Find each import
        data.match(r.IMPORT).forEach (importLine)->
          r.replaceImport resolved, importLine, (imported)->
            data = data.replace importLine, imported
            log inspect(data)
            callback(null, data)
  
  # Replace an _@import_ line with the css
  #
  # `importer` is the parent file that contains the `import`
  # `import` is the _@import_ line. 
  replaceImport : (importer, importLine, callback)->
    dir = path.dirname importer
  
    # Match the file to import
    file = (/\@import\s+[\'\"]([^\'\"]+)/i).exec(importLine)[1]
    
    # Load the file
    fs.readFile path.resolve(dir, file), (err, data)->
      return callback err if err
      callback(data)

module.exports = r
