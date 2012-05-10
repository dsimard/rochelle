fs = require 'fs'

r = 
  load : (file, callback)->
    fs.readFile file, 'utf8', (err, data)->
      unless err
        data = data.replace /\@import/ig, ''
        
      callback data

module.exports = r
