module Succubus
  # Class containing the result of executing a {Grammar}.
  #
  # Result is a subclass of String, so it can be used exactly as if it were a String.
  # Its main purpose is to provide access to metadata about the execution that
  # produced it - namely the +random_seed+ used, and any +errors+ produced.
  #
  # @!attribute [r] random_seed 
  #   @return [Integer] The random seed used to generate this Result.
  #     {#random_seed} can be passed to {Grammar#execute} to exactly repeat the process
  #     that generated this {Result} (for possible debugging purposes, or reporting issues)
  # @!attribute [r] errors
  #   @return [Array<String>] Any errors that occurred during the generation
  #     of this {Result}.
  class Result < String
    attr_reader :random_seed, :errors

    # Create a new Result
    #
    # @private
    #
    # @param [Integer] seed The random seed used to generate this result
    # @param [Array] args Passed through to +super+
    # @param [Proc] block Passed through to +super+
    def initialize(seed, *args, &block)
      @random_seed = seed
      super(*args, &block)
    end

    # Set the errors encountered creating this Result
    #
    # @private
    #
    # @param [Array<String>] errors the errors encountered
    def set_errors(errors)
      @errors = errors
    end
  end
end
