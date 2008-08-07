## simple-parser
A library to parse simple strings into named tokens

### Installation

    $ sudo gem install ddollar-simple-parser --source http://gems.github.com

### Usage

#### As a library
    >> require 'simple-parser'
    >> SimpleParser::String.parse(
         'this is "a test" string',
         ':word1 :: ":phrase1" :word2'
       )

    => { :word1   => 'this',
         :phrase1 => 'a test',
         :word2   => 'string'  }

#### As a mixin
    >> require 'simple-parser'
    >> class String; include SimpleParser::String; end

    >> 'test now'.parse(':word1 :word2')

    => { :word1 => 'test', :word2 => 'now' }
