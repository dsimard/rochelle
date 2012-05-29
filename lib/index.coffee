# How to use as a library
# -----------------------
#
# See `compile` below
#
#     rochelle = require 'rochelle'
#     rochelle.compile 'path/to/file.css', (error, data)->
#       return console.log error if error?
#
#       # Print the compiled CSS to screen
#       console.log data

fs = require 'fs'
path = require 'path'
{log, inspect} = require 'util'
cleanCss = require '../node_modules/clean-css'

r = # The internal name is just `r` because it's short
  IMPORT : /\@import[^;]+;/ig # Matches a import line
  IMPORT_FILE : /\@import\s+(url\(\s*)?[\'\"]([^\'\"]+)/i # Matches the file in import
  
  # Compile
  # -------
  # Compile the main file and aggregate files specified by _@import_
  #
  #`file` is the complete file path
  #
  #`options` (optional) are the options :
  #
  #  - `minify` bool : Minifies the compiled file with [clean-css][]
  #
  #`callback` has two argument `(error, data)` which contains the aggregated css.
  #
  # [clean-css]: https://github.com/GoalSmashers/clean-css
  compile : (file, options={}, callback)->
    # If there's no options, use it as the callback
    [callback, options] = [options, {}] if typeof options == 'function'
    
    fs.realpath file, (err, resolved)->
      return callback?(err) if err
      
      fs.readFile resolved, 'utf8', (err, data)->
        return callback?(err) if err

        # Recursively load the css files and import the css from `@import`
        importFile = (cssFile)->
          # Find each import
          imports = data.match r.IMPORT

          if imports?.length > 0
            importLine = imports[0]
            
            # Load the file
            fileToImport = r.IMPORT_FILE.exec(importLine)[2]
            importCss = path.resolve(path.join(path.dirname(cssFile), fileToImport))
            
            r.loadCss importCss, (loadedCss)->
              data = data.replace importLine, loadedCss
              importFile(importCss)
          else
            callback?(null, data)
              
        importFile(resolved)
  
  # Load a css file
  loadCss : (file, callback)->
    fs.readFile file, (err, data)->
      return callback err if err
      callback(data)
      
module.exports = r
