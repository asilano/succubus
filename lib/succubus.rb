require 'succubus/grammar'
require 'succubus/generator'
require 'succubus/result'

# @author Chris Howlett
module Succubus
  # Raised by {Grammar#initialize Grammar.new} if the grammar defined in the 
  # supplied block cannot be parsed.
  #
  # @!attribute [r] errors
  #   @return [Array<String>] the errors encountered during parsing
  class ParseError < RuntimeError
    attr_reader :errors

    # @private
    def set_errors(errors)
      @errors = errors
    end
  end

  # Raised by {Grammar#execute} if the {Generator} encountered any errors
  # while executing the grammar.
  #
  # @!attribute [r] errors
  #   @return [Array<String>] the errors encountered during execution
  # @!attribute [r] partial
  #   @return [Result] as much of the result as the {Generator} was able
  #     to produce. Typically, this will be a string with missing rules
  #     surrounded by +!!missing!!+. For instance, +"My !!pet!! is nice"+
  class ExecuteError < RuntimeError
    attr_reader :errors, :partial

    # @private
    def set_errors(errors)
      @errors = errors
    end

    # @private
    def set_partial(partial)
      @partial = partial
    end
  end
end
