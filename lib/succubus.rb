require 'succubus/grammar'
require 'succubus/generator'
require 'succubus/result'

module Succubus
  class ParseError < RuntimeError
    attr_accessor :errors
  end
  
  class ExecuteError < RuntimeError
    attr_accessor :errors, :partial
  end
end