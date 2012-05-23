fs = require 'fs'
path = require 'path'
{log, inspect} = require 'util'
cleanCss = require '../node_modules/clean-css'

r = 
  # Regexp to match an import line
  IMPORT : /\@import[^;]+;/ig
  IMPORT_FILE : /\@import\s+(url\(\s*)?[\'\"]([^\'\"]+)/i
  
  # Load the main file and aggregate files specified by _@import_
  #
  # `file` is the complete file path
  #
  # `options` (optional) are the options :
  #
  #   - `minify` : If it should minify the CSS
  #
  #
  # `callback` has two argument. `err` and `data` which contains the aggregated css
  load : (file, options={}, callback)->
    # If there's no options, use it as the callback
    [callback, options] = [options, {}] if typeof options == 'function'
    
    fs.realpath file, (err, resolved)->
      return callback(err) if err
      
      fs.readFile resolved, 'utf8', (err, data)->
        return callback(err) if err
        
        # Find each import
        imports = data.match r.IMPORT
        replace = ->
          if imports?.length > 0
            importLine = imports[0]
            r.replaceImport resolved, importLine, (imported)->
              data = data.replace importLine, imported
              imports = data.match r.IMPORT
              replace()
          else
            # If it should minify the css
            data = cleanCss.process(data) if options.minify
            #log "====\n#{data}\n===="
            callback(null, data)
            
        replace()
  
  # Replace an _@import_ line with the css
  #
  # `importer` is the parent file that contains the `import`
  # `import` is the _@import_ line. 
  replaceImport : (importer, importLine, callback)->
    dir = path.dirname importer
  
    # Match the file to import
    matches = r.IMPORT_FILE.exec(importLine)
    #log "MATCHES for #{inspect(importLine)}"
    #log inspect(matches)
    #log "Matches2 #{inspect(matches[2])}"
    file = matches[2]
    
    # Load the file
    fs.readFile path.resolve(dir, file), (err, data)->
      return callback err if err
      callback(data)

module.exports = r
