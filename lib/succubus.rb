require 'succubus/grammar'
require 'succubus/generator'
require 'succubus/result'

module Succubus
  class ParseError < RuntimeError
    attr_reader :errors

    def set_errors(errors)
      @errors = errors
    end
  end
  
  class ExecuteError < RuntimeError
    attr_reader :errors, :partial

    def set_errors(errors)
      @errors = errors
    end

    def set_partial(partial)
      @partial = partial
    end
  end
end
