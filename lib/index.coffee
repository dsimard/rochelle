fs = require 'fs'
path = require 'path'

r = 
  # Regexp to match an import line
  IMPORT = /\@import[^;$]+/ig
  
  # Load the main file and aggregate files specified by _@import_
  #
  # `file` is the complete file path
  #
  # Callback has two argument. `err` and `data` which contains the aggregated css
  load : (file, callback)->
    fs.realPath file, (err, resolved)->
      fs.readFile resolved, (err, data)->
        callback(err) if err
          
        # Find each import
        data.match(r.IMPORT).forEach (import)->
          r.import resolved, import, (data)->
            data = data.replace import, data
  
  # Replace an _@import_ line with the css
  #
  # `importer` is the parent file that contains the `import`
  # `import` is the _@import_ line. 
  import : (importer, import, callback)->
    dir = path.dirname importer
  
    # Match the file to import
    file = import.match(/\@import\s+[\'\"]([^\'\"]+)/ig)[0]
    
    # Load the file
    fs.readfile path.resolve(dir, file), (err, data)->
      unless err
        callback(data)

module.exports = r
