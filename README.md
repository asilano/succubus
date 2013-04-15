_A random generator based on a generalised Backus-Naur Form grammar_

[![Build Status](https://travis-ci.org/asilano/succubus.png?branch=master)](https://travis-ci.org/asilano/succubus)[![Coverage Status](https://coveralls.io/repos/asilano/succubus/badge.png?branch=master)](https://coveralls.io/r/asilano/succubus)

**Succubus** is a generator which takes stochastic paths through a 
generalised Backus-Naur Form grammar to produce random text. For instance, the following:

    grammar = Succubus::Grammar.new do
      add_rule :base, "I have a <colour> <pet>"
      add_rule :colour, "black", "brown", "white"
      add_rule :pet, "cat", "dog", "rabbit"
    end
    puts grammar.execute :base
    
...might output `I have a black dog`. Or `I have a brown rabbit`. Or any of the other 7 possible combinations of colour and animal.

See the `examples/` folder for more sample generators!

Installation
============
Succubus is a RubyGem. That means it's really easy to install. Simply run:

    gem install succubus
    
and you're done.

Compatability
=============
Succubus is tested against Ruby 1.9.3 and Ruby 2.0 (by Travis - see the little widget up to check we're still passing).
I know of no reason it shouldn't work with Ruby 1.8.7 or 1.9.2 - I just haven't got a test environment that works there yet!

Usage
=====
Everything you need to make and run your own generators is defined in the `Succubus::Grammar` class.

To get started:

1. Require in Succubus:

        require 'succubus'
    
2. Create a new instance of `Succubus::Grammar`, passing it a block:

        require 'succubus'
        grammar = Succubus::Grammar.new do
          # See step 3 for what goes here
        end
        
3. Call `add_rule` within the block. `add_rule` takes a symbol which names the rule, followed by one or more
    strings. When the rule is invoked during grammar execution, exactly one of the strings will be chosen and
    included in the result text. Text in each string is treated literally, except for instances of `<foo>`, which
    instead paste in the result of invoking the rule `:foo`. Rules can be nested as far as you like!
    
        require 'succubus'
        grammar = Succubus::Grammar.new do
          add_rule :silly_name, "<title> <adjective><noun>"
          add_rule :title, "Mr.", "Mrs.", "Professor", "Little Miss"
          add_rule :adjective "<smelladj>", "<colour>", "Smarty"
          add_rule :smelladj, "Smelly", "Poopy", "Floral"
          add_rule :colour, "Green", "Purple"
          add_rule :noun, "pants", "brain", "banana", "nose"
        end
        
4. Call `execute(<rule>)` on your grammar, where `<rule>` is the symbol naming the top-level rule you want to invoke:

        require 'succubus'
        grammar = Succubus::Grammar.new do
          add_rule :silly_name, "<title> <adjective><noun>"
          add_rule :title, "Mr.", "Mrs.", "Professor", "Little Miss"
          add_rule :adjective, "<smelladj>", "<colour>", "Smarty"
          add_rule :smelladj, "Smelly", "Poopy", "Floral"
          add_rule :colour, "Green", "Purple"
          add_rule :noun, "pants", "brain", "banana", "nose"
        end
        
        puts grammar.execute(:silly_name)
        # Professor Purplepants
        
About that name...?
===================
Oh, why **Succubus**? Well, Backus-Naur is usually used to describe or verify legal sentences; 
what you have here is something that uses Backup-Naur to _generate_ sentences. Which is kinda backwards. 
"Backus", backwards, is "Sukcab"; it's just a short hop from there to Succubus.

I did consider "Bacchus" - a sort of drunken Backus - but the gem name was taken.