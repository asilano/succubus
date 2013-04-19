require 'coveralls'
Coveralls.wear! do
	add_filter '/test/'
	add_filter '/spec/'
	add_filter '/examples/'
end
require 'minitest/autorun'
require 'minitest/great_expectations'

require 'turn'
Turn.config do |c|
 # use one of output formats:
 # :outline  - turn's original case/test outline mode [default]
 # :progress - indicates progress with progress bar
 # :dotted   - test/unit's traditional dot-progress mode
 # :pretty   - new pretty reporter
 # :marshal  - dump output as YAML (normal run mode only)
 # :cue      - interactive testing
 c.format  = :outline
 # turn on invoke/execute tracing, enable full backtrace
 c.trace   = true
 # use humanized test names (works only with :outline format)
 c.natural = true
end

require File.dirname(__FILE__) + '/../test/support/fixed_random'