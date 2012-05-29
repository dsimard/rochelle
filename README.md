# rochelle
## Compile CSS in a single file using the @import rule


Strange CSS journey from [Milan to Minsk][]

[![Build Status](https://secure.travis-ci.org/dsimard/rochelle.png?branch=master)](http://travis-ci.org/dsimard/rochelle)

## What does it do?
It takes a css file and aggregate its [`@import`][import] rules to a single css file that has the same name

## Usage
    Usage: coffee ./bin/rochelle.coffee FILES [OPTIONS]

    Options:
      --minify, -m  If should minify the css  [boolean]  [default: false]

## Example
Take these two files :

    /* /path/to/main.css */
    @import 'import.css'
    body {
      background-color:red;
    }
    
and 

    /* path/to/import.css */
    body {
      color:blue;
    }
    
`rochelle /path/to/main.css` will create `/path/to/_main.css`

    body {
      color:blue;
    }
    
    body {
      background-color:red;
    }
        
## Use as a library
Take a look at the [lib][]

[Milan to Minsk]: http://maps.google.com/maps?saddr=Milan&daddr=Minsk
[import]: https://developer.mozilla.org/en/CSS/@import
[lib]: http://dsimard.github.com/rochelle/lib/index.coffee.html
