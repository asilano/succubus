require 'succubus/grammar'
require 'succubus/generator'

module Succubus
  class ParseError < RuntimeError
    attr_accessor :errors
  end
  
  class ExecuteError < RuntimeError
    attr_accessor :errors, :partial
  end
end