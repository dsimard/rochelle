rochelle
========

Strange CSS journey from [Milan to Minsk][]

[![Build Status](https://secure.travis-ci.org/dsimard/rochelle.png?branch=master)](http://travis-ci.org/dsimard/rochelle)

## What does it do?
It takes a css file and aggregate its [`@import`][import] rules to a single css file that has the same name

## Example
Take these two files :

    /* /path/to/main.css */
    @import 'import.css'
    body {
      background-color:red;
    }
    
    /* path/to/import.css */
    body {
      color:blue;
    }
    
Call `rochelle /path/to/main.css` will create `/path/to/_main.css`

    body {
      color:blue;
    }
    
    body {
      background-color:red;
    }
        
## Use as a librairy
Take a look at the [lib][]

[Milan to Minsk]: http://maps.google.com/maps?saddr=Milan&daddr=Minsk&hl=en&sll=49.6531,18.37378&sspn=12.356542,33.815918&geocode=FYG4tQIdSzOMACk9o6HLTMGGRzGQGnttVt4wpg%3BFeByNgMdS6KkASnTah5b08_bRjHZcLXdU7hhCw&mra=ls&t=m&z=6
[import]: https://developer.mozilla.org/en/CSS/@import
[lib]: http://dsimard.github.com/rochelle/lib/index.coffee.html
