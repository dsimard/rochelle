h =
  multipleStyles : ->
    styles = [1..4].map (i)-> "import#{i}.css"          
    styles.push "main.css"
    styles
    
  subStyles : ->
    styles = [2..1].map (i)-> "sub#{i}.css"
    styles.push "main.css"
    styles
    
  folders : ->
    ['simple', 'multiple', 'sub'].map (dir)-> "examples/#{dir}"
    
  mainFiles : ->
    h.folders().map (dir)-> "#{dir}/main.css"
    
  _mainFiles : ->
    h.folders().map (dir)-> "#{dir}/_main.css"
    
    
module.exports = h
